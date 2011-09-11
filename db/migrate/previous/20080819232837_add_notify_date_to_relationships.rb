class AddNotifyDateToRelationships < ActiveRecord::Migration
  def self.up
    add_column :relationships, :last_notified_of_expiration, :datetime, :null => true
    add_column :monetary_contributions, :last_notified_of_expiration, :datetime, :null => true
  end

  def self.down
    remove_column :monetary_contributions, :last_notified_of_expiration
    remove_column :relationships, :last_notified_of_expiration
  end
end
