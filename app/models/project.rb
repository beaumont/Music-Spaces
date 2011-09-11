# == Schema Information
# Schema version: 20081224151519
#
# Table name: users
#
#  id                        :integer(11)     not null, primary key
#  login                     :string(30)      not null
#  display_name              :string(255)
#  email                     :string(255)     not null
#  crypted_password          :string(60)      not null
#  salt                      :string(60)
#  created_at                :datetime        not null
#  updated_at                :datetime        not null
#  created_by_id             :integer(11)     default(1), not null
#  updated_by_id             :integer(11)     default(1), not null
#  remember_token            :string(255)
#  remember_token_expires_at :datetime
#  activation_code           :string(40)
#  activated_at              :datetime
#  type                      :string(10)      default("User"), not null
#  on_behalf_id              :integer(11)     default(0), not null
#  state                     :string(255)     default("active")
#  state_changed_at          :datetime
#  display_name_ru           :string(255)
#  display_name_fr           :string(255)
#  is_private                :boolean(1)
#  email_verified            :string(255)
#

class Project < User

    # invites for project founders, both accepted and pending
    has_many :project_founder_invites, 
          :class_name => 'Invite', 
          :foreign_key => "inviter_id", 
          :conditions => {:circle_id => Invite::TYPES[:founder_circle][:id]}, 
          :order => "user_email, display_name asc", 
          :dependent => :delete_all
    
    # users that are accepted project founders
    # do not use this relationships for any display purposes, it does not perform 'view_permitted' visibilty check
    # only to be used for finding a full founder list for things like permission checks and notifications
    #
    # in views use:
    #   Relationship.find_followers(user, [Relationshiptype.founders], {:join_invites => true | false, :order => '... ', :limit => ..} instead
=begin

    has_and_belongs_to_many :project_founders, :class_name => "User",
        :select => 'users.*',
        :join_table => 'relationships',
        :foreign_key => 'user_id',
        :association_foreign_key => 'related_user_id',
        :conditions => 'relationshiptype_id = 0',
        :uniq => true,
        :order => 'relationships.created_at desc'

=end
    def project_founders
      User.find_by_sql(%Q{
        SELECT distinct `users`.* FROM `users` INNER JOIN `relationships` ON `users`.id = `relationships`.related_user_id
        WHERE (`relationships`.user_id = #{self.id} AND (relationshiptype_id = 0))
        ORDER BY relationships.created_at desc
      }.gsub("\n", " "))
    end

    def project_founders_include?(user)
      user_id = (user.is_a?(Guest) || user.is_a?(User)) ? user.id : user.to_i
      query = %Q{
        SELECT COUNT(*) FROM `users` INNER JOIN `relationships` ON `users`.id = `relationships`.related_user_id
        WHERE (`users`.`id` = #{user_id}) AND (`relationships`.user_id = #{self.id} AND (relationshiptype_id = 0))
        LIMIT 1
      }.gsub("\n", " ")
      User.count_by_sql(query) > 0
    end

    # Show only those founders who don't want to be hidden from the front page
    def front_page_founders(include_invite = false)
      allfounders = if include_invite
        Relationship.find_followers(self, [Relationshiptype.founders], {:order => 'users.login asc', :limit => 100})
      else project_founders
      end
      
      to_hide = preference.shy_founders.collect{|fid| User.find_by_id(fid)}.compact
      showing = (allfounders - to_hide)

      # Add sorting as per founders_display_options
      showing.sort_by do |follower| 
        relationship = Relationship.relationships(self, follower, [Relationshiptype.founders]).first
        relationship.blank? ? 0 : relationship.display_order
      end
      
    end
    
    def crypted_password
      'cantlogin'
    end
    
    def actor
      #better than raising "Project does not have an actor" - Project can crawl into user session as "current user" as a result of mistake
      nil
    end
    
    def project?
      true
    end
  
  def password_required?
    return false
  end

  def init_on_creation(host_user, params)
    self.account_setting = AccountSetting.new(params[:account_setting])

    self.email = host_user.email
    self.crypted_password = 'stub'

    Project.transaction do
      self['private'] = true if params[:hide_project] == "1"
      self.profile = Profile.new((params[:profile] || {}).
              reverse_merge(:occupation => params[:project_type], :account_type_id => Profile::PROJECT))
      self.save!

      self.project_founder_invites.build({
        :user_id => host_user.id, :accepted_at => Time.now,
        :display_name => host_user.display_name, :circle_id => Invite::TYPES[:founder_circle][:id],
        :role_name => params[:founder_role] == 'Your Project Role' ? nil : params[:founder_role],
        :state => 'accepted'
      })
      Tracking::EmailDelivery.create(:tracking_user_id => host_user.id, :tracked_item_type => 'User', :tracked_item_id => self.id)
      Relationship.create_kroogi_relationship(:invite => self.project_founder_invites.first, :skip_activity_message => true)
      Activity.send_message(self, host_user, :created_project) unless self.private?
    end

    host_user.update_attribute(:on_behalf_id, self.id)
  end

  def blank_login_error_msg
    'Project Kroogi name must be provided'.t
  end

  def generic_circle_name(cid, opts = {})
    case cid.to_i
      when -2 then 'Everyone'.t
      when -1 then (opts[:use_i] ? 'Only I'.t : 'Only Me'.t)
      when 0 then 'Hosts'.t
      when 1 then 'Backstage'.t
      when 2 then 'Friends'.t
      when 3 then 'Supporters'.t
      when 4 then 'Fan Club'.t
      when 5 then 'Audience'.t
      when 6 then (opts[:include_site] ? 'Site'.t : '')
      else ''
    end
  end

  def self.default_circles
    [1,4,5]
  end

  def make_activation_code
    #no activation code for projects please
  end

  def escape_content_descriptions?
    return false if !super
    return false if founders.any? {|founder| !founder.escape_content_descriptions?}
    true
  end

  protected

  def default_circle_names
    #lambda needed to have it translated to particular language later
    [lambda{'Studio'.t}, lambda{'Fan Club'.t}, lambda{'Audience'.t}]
  end
  
end
