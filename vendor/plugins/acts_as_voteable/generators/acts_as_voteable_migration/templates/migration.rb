class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.column :points, :integer, :default => 0
      t.column :about, :string
      t.column :user_id, :integer
      
      #STI
      t.column :type, :string
      
      #Polymorhpic Associations
      t.column :voteable_type, :string
      t.column :voteable_id, :integer
      
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :votes
  end
end