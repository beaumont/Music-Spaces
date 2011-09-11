class CreateTrackings < ActiveRecord::Migration
  def self.up
    create_table :trackings do |t|
      t.integer :tracking_user_id, :tracked_item_id
      t.string :tracked_item_type, :type
      t.timestamps
    end
    add_index :trackings, :tracking_user_id
    add_index :trackings, [:tracked_item_type, :tracked_item_id]
    add_index :trackings, :type

    # Set defaults
    puts "Setting defaults (every project owner follows all their projects)"
    User.find(:all, :conditions => {:type => 'User'}).each do |user|
      projects_and_self = user.projects.map(&:id) + [user.id]
      user.preference.receive_emails_for!( projects_and_self )
    end
    
  end

  def self.down
    drop_table :trackings
  end
end
