module Tps
  class Content < ::Album

    CURRENCIES = [['usd', 'USD'], ['rur', 'RUB'], ['eur', 'EUR']].freeze
    DURATIONS = [['0', 'No time limit'.t], ['30', '30 days'.t], ['60', '60 days'.t], ['90', '90 days'.t]].freeze

    named_scope :draft, :conditions => ['state=?', 'draft']
    named_scope :close, :conditions => ['state=?', 'close']
    named_scope :for_user, lambda {|user|
      {:conditions => {:user_id => user.id}} unless user.blank?
    }

    aasm_column :state
#    aasm_initial_state :draft
#    aasm_state :draft
    aasm_state :close

#    aasm_event :public do
#      transitions :from => :draft, :to => :active
#    end

    aasm_event :unpublic do
      transitions :from => :active, :to => :close
    end

    before_create :set_default_state

    has_one :details, :class_name => 'Tps::ContentDetails'
    has_one :cover_art, :class_name => 'CoverArt', :foreign_key => 'downloadable_album_id', :conditions => 'type="CoverArt"', :dependent => :destroy
    has_many :goodies, :class_name => 'Tps::Goodie'
    has_many :participants, :class_name => 'Tps::Participant'

    named_scope :of_project, lambda {|who| { :conditions => ['user_id = ?', who.id]} }

    after_save {|x| x.details.save if x.details && x.details.changed?}

    def entity_name_for_human
      'FundBox'.t
    end

    def commentable?
      self.active?
    end

    def details_object
      details || build_details
    end

    (%w(current_collected_percents current_collected_percents_to5 stopped? inc_participated_count) +
            %w(dec_participated_count increase_collected related_content)).each do |attr_name|
      delegate attr_name.to_sym,       :to => :details_object
    end

    (%w(end_date related_content_id related_content participated_count currently_collected goal_amount) +
     %w(currency duration goodies_delivery_method_id started_at slideshow_delays)).each do |attr_name|
      delegate attr_name.to_sym,       :to => :details_object
      delegate "#{attr_name}=".to_sym, :to => :details_object
    end

    %w(short_description goodies_delivery_description).map{|field| [field, "_#{field}", "#{field}_ru"]}.flatten.each do |attr_name|
      delegate attr_name.to_sym,       :to => :details_object
      delegate "#{attr_name}=".to_sym, :to => :details_object
    end

    %w(offer_goodies invite_to_interested_circle specific_amount specific_end_date).each do |attr_name|
      delegate attr_name.to_sym,       :to => :details_object
      delegate "#{attr_name}=".to_sym, :to => :details_object
      delegate "#{attr_name}?".to_sym, :to => :details_object
    end

    alias :old_cover_art :cover_art
    def cover_art
      result = old_cover_art
      result ||= related_content.cover_art if related_content
      result
    end

    alias :old_cover_art_url :cover_art_url
    def cover_art_url
      result = old_cover_art
      result ||= related_content.cover_art_url if related_content
      result
    end

    def action_cache_key_suffix(controller)
      key = [updated_at.to_i, comment_count]
      key += [Date.today.to_s(:db), goal_amount, participated_count, currently_collected]

      key
    end

    def editable?
      false
    end

    def tracks
      related_content ? related_content.tracks : Content.find_by_sql(album_contents_sql + " AND type = 'Track'")
    end

    def images
      @images ||= Content.find_by_sql(album_contents_sql + " AND type IN ('Tps::Image')")
    end

    def stop
      details.update_attribute(:stopped, true)
    end

    def payments
      return @payments if @payments
      @payments = MonetaryDonation.find(:all, :conditions =>
              ['content_type = ? and receiver_account_setting_id = ?', GoodieTicket.name, self.user.account_setting.id])
      @payments = @payments.select {|tr| tr.content.content_id == self.id}
    end

    def make_money_available
      payments.each {|d| d.available_at = Time.now - 1.minute; d.apply_to_balance!}      
    end

    private

    def set_default_state
      # Initial is public
#      self.state = 'draft'
    end

  end
end