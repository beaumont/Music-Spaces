class RemoveCostLocalFromMovableCountries < ActiveRecord::Migration
  def self.up
    remove_column :movable_numbers, :cost_local
    remove_column :movable_numbers, :formatted_cost_local
  end

  def self.down
    add_column :movable_numbers, :formatted_cost_local, :string
    add_column :movable_numbers, :formatted_cost, :string
  end
end
