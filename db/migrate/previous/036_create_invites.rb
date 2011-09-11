class CreateInvites < ActiveRecord::Migration
  def self.up
    create_table :invites, :options => 'TYPE=MyISAM', :force => true do |t|
      t.column :project_id, :integer, :default => 0, :null => false
      t.column :user_id, :integer
      t.column :user_email, :string, :length => 255
      t.column :created_at, :datetime, :null => false
      t.column :created_by_id, :integer, :default => 0, :null => false
      t.column :invitation, :text
    end
  end

  def self.down
    drop_table :invites
  end
end
