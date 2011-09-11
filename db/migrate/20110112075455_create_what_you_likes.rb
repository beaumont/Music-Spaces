class CreateWhatYouLikes < ActiveRecord::Migration
  def self.up
    create_table :what_you_likes do |t|
      t.integer :user_id
      t.integer :related_user_id
      t.integer :relationshiptype_id
      t.timestamps
    end
  end

  def self.down
    drop_table :what_you_likes
  end
end
