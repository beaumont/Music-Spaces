
# Class definition has changed, will need to store old relationship here before we can remove it
class Content < ActiveRecord::Base
  has_and_belongs_to_many :relationshiptypes
end




class OverhaulingContentPermissions < ActiveRecord::Migration
  # Shifting from storing an array of relationshiptypes to just noting the furthest circle that has access

  def self.up
    unless Content.column_names.include?('relationshiptype_id')
      add_column :contents, :relationshiptype_id, :integer, :nil => true
    end

    puts "Updating permissions for ALL content items..."
    
    total_items = Content.count
    per_set = total_items / 100
    puts "**********************************************************"
    puts "* Breaking #{total_items} into 100 runs of #{per_set} each"
    puts "**********************************************************"
    puts "\n\n\n"
    
    (0..100).each do |run|
      puts "* Run #{run}:"
      puts "\tLoading items..."
      items = Content.find(:all, :limit => per_set, :offset => run * per_set, :include => :relationshiptypes)
      puts "\tLoaded #{items.size} content items (from #{run*per_set} to #{run*per_set + per_set})..."
      items.each do |content|
        relation_ids = content.relationshiptype_ids.sort
      
        # nil will mean no restriction -- show to everybody
        next if relation_ids.empty? || relation_ids.first == Relationshiptype.everyone || relation_ids.first > Relationshiptype.interested
      
        # otherwise save most restrictive value
        content.update_attribute(:relationshiptype_id, relation_ids.first)
      end
      puts "\tProcessing this run complete"
    end

    puts "\n\nDone!! Defaulting nil relationshiptypes to Public\n\n"
    Content.update_all ['relationshiptype_id=?', Relationshiptype.everyone], 'relationshiptype_id IS NULL'

    
    #puts "SLEEPING BEFORE DESTROYING TABLE: 10 seconds!"
    #sleep(10)
    
    drop_table :contents_relationshiptypes
  end

  def self.down
    raise "Ug, too lazy to implement if not necessary"
  end
end
