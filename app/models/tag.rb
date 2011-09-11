# == Schema Information
# Schema version: 20081006211752
#
# Table name: tags
#
#  id   :integer(11)     not null, primary key
#  name :string(255)
#

class Tag < ActiveRecord::Base
  has_many :taggings
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  cattr_accessor :destroy_unused
  self.destroy_unused = false

  # #1931 - tags should now all be lowercase
  def name=(str)
    self['name'] = str.to_s.downcase
  end
    
  # LIKE is used for cross-database case-insensitivity
  def self.find_or_create_with_like_by_name(name)
    find(:first, :conditions => ["name LIKE ?", name]) || create(:name => name)
  end
  
  def ==(object)
    super || (object.is_a?(Tag) && name == object.name)
  end
  
  def to_s
    name
  end
  
  def count
    read_attribute(:count).to_i
  end
  
  def self.counts_for_all_tags(options = {})
    find(:all, generic_tag_count_options(options))
  end
  
  def self.generic_tag_count_options(options = {})
    options.assert_valid_keys :start_at, :end_at, :conditions, :at_least, :at_most, :order, :limit
    
    scope = scope(:find)
    start_at = sanitize_sql(["#{Tagging.table_name}.created_at >= ?", options.delete(:start_at)]) if options[:start_at]
    end_at = sanitize_sql(["#{Tagging.table_name}.created_at <= ?", options.delete(:end_at)]) if options[:end_at]
    
    conditions = [
      options[:conditions],
      scope && scope[:conditions],
      start_at,
      end_at
    ]
    
    conditions << type_condition unless descends_from_active_record? 
    conditions.compact!
    conditions = conditions.join(' AND ')
    
    joins = "INNER JOIN #{Tagging.table_name} ON #{Tag.table_name}.id = #{Tagging.table_name}.tag_id"
    
    at_least  = sanitize_sql(['COUNT(*) >= ?', options.delete(:at_least)]) if options[:at_least]
    at_most   = sanitize_sql(['COUNT(*) <= ?', options.delete(:at_most)]) if options[:at_most]
    having    = [at_least, at_most].compact.join(' AND ')
    group_by  = "#{Tag.table_name}.id, #{Tag.table_name}.name HAVING COUNT(*) > 0"
    group_by << " AND #{having}" unless having.blank?
    
    { :select     => "#{Tag.table_name}.id, #{Tag.table_name}.name, COUNT(*) AS count", 
      :joins      => joins,
      :conditions => conditions,
      :group      => group_by
    }.update(options)
  end
  
end
