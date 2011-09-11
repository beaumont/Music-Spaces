class CirclePreferences < ActiveRecord::Migration
  def self.up
    # Serialized column, defaults to empty array
    add_column :preferences, :active_circle_ids, :string, :default => '--- []'

    # Set all preferences to reflect their current circle settings
    Preference.find(:all).each do |p|
      p.update_attribute(:active_circle_ids, Invite.default_circle_ids_for(p.user))
    end
    
    add_column :user_kroogs, :name,               :string
    add_column :user_kroogs, :open,               :boolean, :default => true
    add_column :user_kroogs, :can_request_invite, :boolean, :default => false

    # Done with this -- all users can have all circles, now
    remove_column :preferences, :full_kroogi_circles
  end

  def self.down
    add_column :preferences,    :full_kroogi_circles, :boolean

    remove_column :preferences, :active_circle_ids
    remove_column :user_kroogs, :name
    remove_column :user_kroogs, :open
    remove_column :user_kroogs, :can_request_invite
  end
end
