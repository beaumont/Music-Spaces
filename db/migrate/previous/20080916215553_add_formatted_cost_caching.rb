class AddFormattedCostCaching < ActiveRecord::Migration
  def self.up
    unless Movable::Number.column_names.include?('formatted_cost')
      add_column :movable_numbers, :formatted_cost, :string
    end
    unless Movable::Number.column_names.include?('formatted_cost_local')
      add_column :movable_numbers, :formatted_cost_local, :string
    end
  end

  def self.down
    remove_column :movable_numbers, :formatted_cost
    remove_column :movable_numbers, :formatted_cost_local
  end
end
