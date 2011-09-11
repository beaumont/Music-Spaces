class UpdateTpsTables < ActiveRecord::Migration
  def self.up
    add_column :tps_content_details, :currency, :string, :limit => 10, :default => 'usd'
    add_column :tps_content_details, :specific_amount, :boolean, :default => false
    add_column :tps_content_details, :duration, :integer, :default => 0
    add_column :tps_content_details, :started_at, :date
    add_column :tps_content_details, :offer_goodies, :boolean, :default => false
    add_column :tps_content_details, :goodies_delivery_description, :text
    add_column :tps_content_details, :goodies_delivery_description_ru, :text
    add_column :tps_content_details, :invite_to_interested_circle, :boolean, :default => true

    add_column :tps_goodies, :currency, :string, :default => 'usd'
    add_column :tps_goodies, :delivery_method_group, :string, :default => 'A'
  end

  def self.down
    remove_column :tps_content_details, :currency
    remove_column :tps_content_details, :specific_amount
    remove_column :tps_content_details, :duration
    remove_column :tps_content_details, :started_at
    remove_column :tps_content_details, :offer_goodies
    remove_column :tps_content_details, :goodies_delivery_description
    remove_column :tps_content_details, :goodies_delivery_description_ru
    remove_column :tps_content_details, :invite_to_interested_circle

    remove_column :tps_goodies, :currency
    remove_column :tps_goodies, :delivery_method_group
  end
end
