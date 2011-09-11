class CreateKroogiSettings < ActiveRecord::Migration
  def self.up
    create_table :kroogi_settings, :options => 'TYPE=MyISAM', :force => true do |t|
        t.column :user_id, :integer, :null => false
        t.column :invitation_type, :integer, :null => false
        t.column :price, :decimal
        t.column :created_at, :datetime, :null => false
        t.column :updated_at, :datetime, :null => false
        t.column :created_by_id, :integer, :null => false
        t.column :updated_by_id, :integer, :null => false
    end
    add_index(:kroogi_settings, :user_id)
    add_column :invites, :price, :decimal
    
  end

  def self.down
    drop_table :kroogi_settings
    remove_column :invites, :price
  end
end
