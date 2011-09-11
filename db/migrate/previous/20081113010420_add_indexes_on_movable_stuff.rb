class AddIndexesOnMovableStuff < ActiveRecord::Migration
  def self.up
    add_index :movable_operators, [:movable_country_id, :version]
    add_index :movable_numbers, [:movable_operator_id, :version]
  end

  def self.down
    remove_index :movable_operators, [:movable_country_id, :version]
    remove_index :movable_numbers, [:movable_operator_id, :version]
  end
end
