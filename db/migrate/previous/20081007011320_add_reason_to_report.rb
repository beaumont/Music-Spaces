class AddReasonToReport < ActiveRecord::Migration
  def self.up
    add_column :reports, :reason, :string
    add_index :reports, :reason
  end

  def self.down
    remove_column :reports, :reason
  end
end
