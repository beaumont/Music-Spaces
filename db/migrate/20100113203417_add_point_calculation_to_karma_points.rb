class AddPointCalculationToKarmaPoints < ActiveRecord::Migration
  def self.up
    add_column :karma_points, :points, :integer, :default => 0
    add_index :karma_points, [:referrer_id, :action], :name => "karma_referrer_action"
    KarmaPoint.all.each do |k|
      k.save(false)
    end
  end

  def self.down
    remove_index :karma_points, :name => :karma_referrer_action
    remove_column :karma_points, :points
  end
end
