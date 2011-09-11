class ChangeAnnouncementToBoardInMc < ActiveRecord::Migration
  def self.up
    rename_column :monetary_contributions, :announcement_id, :board_id
    add_column :monetary_contributions, :currency_type, :string
  end

  def self.down
    rename_column :monetary_contributions, :board_id, :announcement_id
    remove_column :monetary_contributions, :currency_type
  end
end
