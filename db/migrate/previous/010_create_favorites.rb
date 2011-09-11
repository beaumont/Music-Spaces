class CreateFavorites < ActiveRecord::Migration
  def self.up
    create_table :favorites, :options => 'TYPE=MyISAM', :force => true do |t|
      t.column :user_id,            :integer
      t.column :favorable_type,     :string, :limit => 30
      t.column :favorable_id,       :integer
      t.column :created_at,         :datetime
      t.column :updated_at,         :datetime
    end
  end

  def self.down
    drop_table :favorites
  end
end
