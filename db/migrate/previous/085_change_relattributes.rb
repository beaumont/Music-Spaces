class ChangeRelattributes < ActiveRecord::Migration
  def self.up
    change_column(:relationships, :attributebits, :integer, :default => 0, :null => false)
  end

  def self.down
    change_column(:relationships, :attributebits, :integer, :null => true)
  end
  
end
