class BasicUsersNeedToBeShownWizards < ActiveRecord::Migration
  def self.up
    add_column :rare_user_settings, :need_to_show_wizard, :boolean    
  end

  def self.down
  end
end
