class CreateBodyCopies < ActiveRecord::Migration
  def self.up
    create_table :body_copy do |t|
      t.string :name, :description
      t.text :copy, :copy_ru
      t.timestamps
    end
    add_index :body_copy, :name
  end

  def self.down
    drop_table :body_copy
  end
end
