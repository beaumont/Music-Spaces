class AddContextToTaggings < ActiveRecord::Migration
  def self.up
    add_column :taggings, :context, :string
    current_tags = ActiveRecord::Base.connection.update_sql(%{update `taggings` set `context` = 'occupation' where `taggable_type` = 'Profile'})
    puts "Records Updated: #{current_tags}\n"
  end

  def self.down
    remove_column :taggings, :context
  end
end
