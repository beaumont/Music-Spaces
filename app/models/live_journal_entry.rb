# == Schema Information
# Schema version: 20081216224705
#
# Table name: live_journal_entries
#
#  id              :integer(11)     not null, primary key
#  account_id      :integer(11)     not null
#  anum            :integer(11)
#  journal_item_id :integer(11)
#  backdated       :boolean(1)
#  preformatted    :boolean(1)
#  event           :text
#  subject         :string(255)
#  music           :string(255)
#  location        :string(255)
#  security        :string(255)
#  screening       :string(255)
#  posted_at       :datetime
#  created_at      :datetime
#  updated_at      :datetime
#  content_id      :integer(11)     default(0), not null
#  comments        :integer(11)     default(0), not null
#  taglist         :string(2048)
#  event_cut       :text
#  event_formatted :text
#

# This class provides local caching for LiveJournal entries.
require 'live_journal_tags'
class LiveJournalEntry < ActiveRecord::Base
  xss_terminate :except => [:event_cut, :event_formatted, :event, :security, :screening, :commenttype, :security, :screening, :taglist]

  belongs_to :account
  belongs_to :blogentry, :foreign_key => 'content_id', :class_name => 'Blog', :dependent => :destroy
  validates_presence_of :account_id
  
  has_many :comments, :class_name => 'LiveJournalComment', :foreign_key => 'journal_item_id', :dependent => :destroy
  
  serialize :security
  serialize :screening
  
  # Mapping livejournal attributes
  # :attribute => :entry_method
  BODY_MAPPINGS = {
    :anum            => :anum,
    :journal_item_id => :itemid,
    :backdated       => :backdated,
    :preformatted    => :preformatted,
    :screening       => :screening,
    :subject         => :subject,
    :event           => :event,
    :location        => :location,
    :security        => :security,
    :music           => :music,
    :posted_at       => :time,
    :taglist         => :taglist
  }.freeze
    
  # Update the entries in the local cache for a specified account
  # NOTE: Must be an authorized lj account to work as thats what the API calls for
  # TODO: refactor this in to smaller methods and blocks, this is ugly and hard to test.
  
  # NOTE: Also last_sync should be the time of the last entry (or nil/6 months if new)
  def self.update_cache_for(account, forced = false)
    return false if account.nil?
    user = account.authenticate
    return false unless user

    retries = 0

    begin

      # First sync should only allow up to 6 months of entries to be
      # imported in to the system during the inital import. Last sync
      # if already set should be the time of the last successfult 
      # journal entry we imported. They also expect a nicely formatted
      # string to be passed in "Y-M-D H:M:S" format based on GMT (or
      # simply a standard time that you consistently use.
      last_sync = account.last_sync
      if account.last_sync.nil? || account.last_sync < 6.months.ago
        last_sync = 6.months.ago
      end
    
      # If we must retry, livejournal doesn't like us using the same
      # timestamp on our next request, so lets bump it back a bit.
      # Worst that happens is we resync an existing entry (vs errors)
      last_sync -= rand(10)
      last_sync = last_sync.strftime('%Y-%m-%d %H:%M:%S')

      # Create an entry sync object
      sync = LiveJournal::Sync::Entries.new(user, last_sync)
    
      # Retrieve Metatdata (Don't ask me, I didn't write it.. 
      # seems to be required so set up the sync, but should
      # have be integrated a bit cleaner.)
      sync.run_syncitems {|cur, total|}
    
      # Pull Journal Entries
      sync.run_sync do |entries_hash, lastsync, remaining|
      
        entries_hash.entries.each do |id, a_entry|
        
          entry = account.entries.find_or_initialize_by_journal_item_id(id)
        
          BODY_MAPPINGS.each do |db_col, meta_col|
            if db_col == :event
              entry.event = crap_as_html(a_entry.event)
            elsif db_col == :subject
              entry.subject = crap_as_html(a_entry.subject)
            elsif db_col == :taglist && !a_entry.taglist.blank?
              entry.taglist = (YAML::load(a_entry.taglist).join(' ') rescue nil)
            else
              entry.send("#{db_col}=", a_entry.send("#{meta_col}"))
            end
          end

          # Only allow entries set in the past to be imported. 
          if entry.posted_at < Time.now
        
            # Check to make sure the user wants to import this entry.
            import = false
            case entry.security
            when :public
              import = true
            when :friend, :friends
              import = account.allow_friends?
            else # me & custom
              import = account.import_mine?
            end

            if import
              # Lets import it!
              LiveJournalEntry.transaction do
                Thread.current['user'] ||= account.user
                new_entry = entry.new_record?
                entry.save!
                content = Blog.active.find_by_id(entry.content_id)
                content ||= Blog.new(:user_id => account.user.id)
                content.post = entry
                content.save(false) # get an id for passing along
                LiveJournalEntry.transpose_lj_tags(entry, content.id)
                content.save!
          
                # TODO: Do not send blocked ones...
                Activity.send_message(content, account.user, :published_blog, :created_at => entry.posted_at) if new_entry
              end
            else
              # They dont want this imported, or changed their settings later.
              entry.blogentry.destroy if entry.blogentry
              entry.destroy
            end
          
          end #if before now...

          # Set the account's last sync to the last entry that was pulled (regardless of import)
          account.update_attribute(:last_sync, Time.parse(lastsync)) if lastsync
        
        end

        # If this was a manual sync, make sure we record it.
        account.update_attribute(:last_manual_sync, Time.now.utc) if forced
      end
    
    # If there is a protocol exception, it is generally due to sync issues
    # with timestamped requests, so lets retry a few times...  
    rescue LiveJournal::Request::ProtocolException
      retries += 1
      retry unless retries > 3
      logger.warn("[LJ Sync Retry] - Retry #{retries+1} for account ##{account.id}")
    end
    
  end
  
  protected
  
  # LJ sends us html in the form of crap
  def self.crap_as_html(crap, server = LiveJournal::DEFAULT_SERVER)
    # I'd like to use REXML but the content isn't XML, so REs it is!
    return nil if crap.blank?
    html = crap.dup
    html.gsub!(/(\w+)=([^'"]+?)(?=[>\s])/) {|a| "#{$1}=\"#{$2}\""} # Putting "quotes" around non-quoted attributes
    html.gsub!("<br/>") unless @preformatted
    html
  end
  
  # Handles lj tag replacement and cuts
  def self.transpose_lj_tags(entry, content_id)
    formatted_html  = LiveJournalTags.parse(entry, content_id)
    entry.event_cut = formatted_html[:cut]
    entry.event_formatted = formatted_html[:full]
    entry.save(false)
  end
  
end
