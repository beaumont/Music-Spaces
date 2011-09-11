class CreateTpsGoodies < ActiveRecord::Migration
  def self.up
    create_table :tps_goodies, :force => true do |t|
      t.integer :content_id, :null => false
      t.integer :identifier, :null => false
      t.string :title
      t.string :title_ru
      t.decimal :price, :precision => 10, :scale => 2, :default => 0
      t.integer :left
      t.timestamps
    end
    add_index(:tps_goodies, [:content_id, :identifier], :unique => true)

    change_column(:tps_content_details, :participated_count, :integer, :default => 0)
    Tps::ContentDetails.update_all('participated_count = 0')
  end

  def self.down
  end
end
