# == Schema Information
# Schema version: 20081126233441
#
# Table name: featured_items
#
#  id                       :integer(11)     not null, primary key
#  item_id                  :integer(11)
#  item_type                :string(255)
#  is_content               :boolean(1)
#  is_project               :boolean(1)
#  currently_featured       :boolean(1)
#  created_at               :datetime
#  updated_at               :datetime
#  editorial_db_store_id    :integer(11)
#  editorial_db_store_ru_id :integer(11)
#  synopsis                 :string(255)
#  synopsis_ru              :string(255)
#

class FeaturedItem < ActiveRecord::Base
  belongs_to :item, :polymorphic => true
  belongs_to :content, :foreign_key => 'item_id'

  # attr_accessor :editorial, :editorial_ru
  translates_virtual_attribute :editorial

  translates :synopsis, :base_as_default => true
  
  # Pass along permissions to item
  def is_view_permitted?(user_or_project)
    item ? item.is_view_permitted?(user_or_project) : nil
  end
  
  # Creates the new featured item. If already exists, ensures is set to currently featured.
  def self.feature!(item, editorial = nil, editorial_ru = nil, synopsis = nil, synopsis_ru = nil)
    return nil unless item.is_a?(User) || item.is_a?(Content)
    id_hash = {:item_type => item.class.to_s, :item_id => item.id}
    fitem = FeaturedItem.find(:first, :conditions => id_hash)
    fitem ||= FeaturedItem.create(id_hash)
    
    send_alert = !fitem.currently_featured?   # Don't send if idiot admin is re-featuring something that's currently featured
    fitem.update_attributes({
      :currently_featured => true, 
      :is_project => item.is_a?(User), 
      :is_content => item.is_a?(Content), 
      :editorial => editorial,
      :editorial_ru => editorial_ru,
      :synopsis => synopsis,
      :synopsis_ru => synopsis_ru
    })
    Activity.send_message(item, nil, item.kind_of?(User) ? :user_featured : :content_featured) if send_alert
    fitem
  end
  
  # Return featured item instance for the given item, if it has one
  def self.meta_for(item)
    FeaturedItem.find(:first, :conditions => {:item_type => item.class.to_s, :item_id => item.id})
  end
  
  # Returns n random currently-featured projects
  def self.projects(n=1, options = {})
    get(n, {:is_project => true, :currently_featured => true}, options)
  end

  # Returns n random currently-featured content items. Note that is_content is used because content items will have different classes.
  def self.items(n=4, options = {})
    criteria = "is_content=? and currently_featured=? and item_type #{options.delete(:downloadable) ? '' : 'not'} in (?)"
    values = [true, true, [FolderWithDownloadables.name, MusicAlbum.name]]
    if options[:only_languages] == 'en'
      criteria << " and contents.title is not null and contents.title != '' and users.display_name is not null and users.display_name != ''"
    else
      #looks like it's critical for :include => :content to work
      criteria << " and contents.title = contents.title"
    end
    conditions = [criteria] + values
    options.reverse_merge! :convert => true
    n = nil if n == :all

    items = FeaturedItem.find(:all, :select => 'featured_items.*',
                              :from => 'featured_items',
                              :joins => 'inner join users on contents.user_id = users.id',
                              :conditions => conditions, :limit => n, :order => 'rand()', :include => :content)

    if options[:convert]
      items.map {|i| i.content}
    else
      items
    end
  end
  
  def self.download_albums(n=4, options = {})
    items(n, options.merge(:downloadable => true))
  end
  
  # Makes this no longer featured
  def defeature!
    update_attribute(:currently_featured, false)
  end
  
  protected
  
  def self.get(n, conditions, options)
    options.reverse_merge! :convert => true
    n = nil if n == :all

    items = FeaturedItem.find(:all, :conditions => conditions, :limit => n,
      :order => 'rand()')
    
    if options[:convert]
      items.map {|i| i.item}
    else
      items
    end
  end
end
