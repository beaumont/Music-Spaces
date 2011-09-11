class CreateUserKroogs < ActiveRecord::Migration
  def self.up
    create_table :user_kroogs do |t|
      t.belongs_to :user
      t.integer :relationshiptype_id, :default => 5, :null => false
      t.decimal :price
      t.integer :created_by_id, :default => 0, :null => false
      t.integer :updated_by_id, :default => 0, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :user_kroogs
  end
end