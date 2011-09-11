require 'livejournal/sync'

module LiveJournal
  # LJ gem fails to create this exception class before calling it
  class LiveJournalException < Exception; end

  module Request
    
    # Provide accessors for default API credentials (for public imports)
    class Config
      cattr_accessor :default_username, :default_password
    end
    
    # Ignore any new properties by default instead of raising an exception
    class GetEvents      
      def initialize_with_strict(user, opts)
        opts.merge!(:strict => false) unless opts.keys.include?(:strict)
        initialize_without_strict(user, opts)
      end
      
      alias_method_chain :initialize, :strict
    end
  end
  
  
  class Entry
    def load_prop(name, value, strict=false) #:nodoc:#
      case name
      when 'current_mood'
        @mood = value.to_i
      when 'current_moodid'
        @moodid = value.to_i
      when 'current_music'
        @music = value
      when 'current_location'
        @location = value
      when 'taglist'
        @taglist = value.split(/, /).sort
      when 'picture_keyword'
        @pickeyword = value
      when 'opt_preformatted'
        @preformatted = value == '1'
      when 'opt_nocomments'
        @comments = :none
      when 'opt_noemail'
        @comments = :noemail
      when 'opt_backdated'
        @backdated = value == '1'
      when 'opt_screening'
        case value
        when 'A'; @screening = :all
        when 'R'; @screening = :anonymous
        when 'F'; @screening = :nonfriends
        when 'N'; @screening = :none
        # they keep sending us fraggin 'D' as a value....
        # but it's not even mentioned in their API docs.
        # at some point we were storing this value as :defualt
        # so that's what I'm doing again.
        when 'D'; @screening = :default
        else
          raise LiveJournalException,
            "unknown opt_screening value #{value.inspect}"
        end
      when 'hasscreened'
        @screened = value == '1'
      else
        # LJ keeps adding props, so we store all leftovers in a hash.
        # Unfortunately, we don't know which of these need to be passed
        # on to new entries.  This may mean we drop some data when we
        # round-trip.
        #
        # Some we've seen so far:
        #   revnum, revtime, commentalter, unknown8bit, useragent
        @props[name] = value

        unless KNOWN_EXTRA_PROPS.include? name or not strict
          raise Request::ProtocolException, "unknown prop (#{name}, #{value})"
        end
      end # big ass case declaration
    end # #load_prop
  end # Entry
end

# These are required missing props that are not included in the LiveJournal Library.
LiveJournal::Entry::KNOWN_EXTRA_PROPS.push('personifi_lang')
LiveJournal::Entry::KNOWN_EXTRA_PROPS.push('personifi_word_count')
LiveJournal::Entry::KNOWN_EXTRA_PROPS.push('used_rte')

