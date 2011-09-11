class CreateAdminFlashes < ActiveRecord::Migration
  def self.up
    create_table :admin_flashes do |t|
      t.string :message
      t.datetime :start, :end
      t.integer :priority, :default => 0, :nil => false
      t.boolean :shown, :default => true
      t.timestamps
    end
    add_index :admin_flashes, [:shown, :priority]
  end

  def self.down
    drop_table :admin_flashes
  end
end
