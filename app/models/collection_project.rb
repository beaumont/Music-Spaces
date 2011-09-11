# == Schema Information
# Schema version: 20090211222143
#
# Table name: users
#
#  id                        :integer(11)     not null, primary key
#  login                     :string(30)      default(""), not null
#  display_name              :string(255)
#  email                     :string(255)     default(""), not null
#  crypted_password          :string(60)      default(""), not null
#  salt                      :string(60)
#  created_at                :datetime        not null
#  updated_at                :datetime        not null
#  created_by_id             :integer(11)     default(1), not null
#  updated_by_id             :integer(11)     default(1), not null
#  remember_token            :string(255)
#  remember_token_expires_at :datetime
#  activation_code           :string(40)
#  activated_at              :datetime
#  type                      :string(30)      default("User")
#  on_behalf_id              :integer(11)     default(0), not null
#  state                     :string(255)     default("active")
#  state_changed_at          :datetime
#  display_name_ru           :string(255)
#  display_name_fr           :string(255)
#  is_private                :boolean(1)
#  email_verified            :string(255)
#

class CollectionProject < Project
  has_many :inclusions, :class_name => 'CollectionInclusion', :foreign_key => 'parent_id'
  has_many :stop_list_items, :class_name => 'CollectionStopListItem', :foreign_key => 'parent_id'
  has_many :children_pacs, :class_name => 'ProjectAsContent', :foreign_key => 'user_id' 

  def entity_name_for_human
    # 'Collection'.t
    'Collection'
  end

  def pac_contents
    self.contents.all(:conditions => {:type => 'ProjectAsContent'})
  end
  
  def make_interested_of_children
    #it doesn't go into children recursively because we don't unide them recursively (yet)
    self.pac_contents.each do |pac|
      pac.make_container_interested
    end
  end

  def unhide_owned_children
    self.pac_contents.each do |pac|
      c = pac.body_project
      if c.collection? && c.private? && current_user.is_self_or_owner?(c)
        c.unhide
      end
    end
  end

  def self.repopulate_all_inclusions(options = {})
    log.debug "hello from CP.repopulate_all_inclusions!"
    user_idx = 0
    count = self.active.count 
    self.active.each do |col|
      puts "Processed #{user_idx} users out of #{count}." if options[:stdout_progress] && user_idx % 4 == 0 
      user_idx += 1
      col.pac_contents.map do |pac|
        pac.repopulate_collection_inclusions(:use_collection_inclusions_to_find_ancestors => false)
      end
    end

    puts "Processed #{user_idx} collections." if options[:stdout_progress]
  end

  #Finds some path to some root of collections inclusion chain to this collection
  def collections_ancestory_chain
    ProjectAsContent.find_ancestory_chain_with(:root, self.id) || [self]
  end

  def has_unstopped_inclusion?(questionably_followed_id)
    CollectionInclusion.unstopped.children_of(self.id).map(&:child_user_id).include?(questionably_followed_id)
  end

  def all_direct_children_followed_by?(follower)
    children = self.inclusions.direct.map(&:child_user_id)
    follower.follows?(children) == children.count
  end

  def all_direct_children_liked_by?(follower)
    children = self.inclusions.direct.map(&:child_user_id)
    follower.likes?(children) == children.count
  end

  def self.default_circles
    [5]
  end

  protected

  def default_circle_names
    #lambda needed to have it translated to particular language later
    [lambda{'Audience'.t}]
  end

end
