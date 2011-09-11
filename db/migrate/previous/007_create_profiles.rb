class CreateProfiles < ActiveRecord::Migration
    def self.up
    create_table "profiles", :options => 'TYPE=MyISAM', :force => true do |t|
      t.column :user_id,                   :integer, :default => 1, :null => false
      t.column :band_name,                 :string,  :limit => 255
      t.column :avatar_path,               :string, :limit => 255
      t.column :bio,                       :text
    end
    add_index(:profiles, :user_id, :unique => true)
    
    
  end

  def self.down
    drop_table "profiles"
  end
end
