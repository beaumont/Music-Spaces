class AddModelToggles < ActiveRecord::Migration
  def self.up
    create_table :toggles, :force => true do |t|
      t.string :name
      t.boolean :value
    end
    add_index :toggles, :name
  end

  def self.down
    drop_table :toggles
  end
end
