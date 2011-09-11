class CreateFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :feedbacks do |t|
      t.integer :user_id
      t.text :complaint
      t.text :environment
      t.string :ip
      t.timestamps
    end
  end

  def self.down
    drop_table :feedbacks
  end
end
