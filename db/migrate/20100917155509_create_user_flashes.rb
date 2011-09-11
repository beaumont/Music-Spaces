class CreateUserFlashes < ActiveRecord::Migration
  def self.up
    create_table :user_flashes, :force => true do |t|
      t.integer :user_id, :null => false
      t.string :key, :null => false
      t.text :data
      t.timestamps
    end
    add_index :user_flashes, [:user_id, :key]

  end

  def self.down
  end
end
