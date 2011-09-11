class EnableBodyCopyHashes < ActiveRecord::Migration
  def self.up
    add_column :body_copy, :key, :string
    add_index :body_copy, :key
    
    BodyCopy.find(:all).map(&:save)
  end

  def self.down
    remove_index :body_copy, :key
    remove_column :body_copy, :key
  end
end
