class MakeSuspectByDefault < ActiveRecord::Migration
  def self.up
    change_column :monetary_contributions, :suspect, :boolean, :default => true
  end

  def self.down
  end
end
