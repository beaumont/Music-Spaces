class CreateSmscoinVersions < ActiveRecord::Migration
  def self.up
    create_table :smscoin_versions, :force => true do |t|
      t.text :json, :limit => 2.megabytes
      t.datetime :created_at, :null => false
      t.datetime :last_checked_at, :null => false
      t.string :cached_data_digest, :null => false
      t.boolean :finished, :null => false, :default => false
    end
  end

  def self.down
  end
end
