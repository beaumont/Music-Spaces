class UpdateMonetaryContributionsTable < ActiveRecord::Migration
  def self.up
    remove_column :monetary_contributions, :address_state
    remove_column :monetary_contributions, :address_zip
    remove_column :monetary_contributions, :receiver_id
    rename_column :monetary_contributions, :receiver_email, :payer_email
    add_column    :monetary_contributions, :suspect, :boolean, :default => false
  end

  def self.down
    remove_column :monetary_contributions, :suspect
    rename_column :monetary_contributions, :payer_email, :receiver_email
    add_column    :monetary_contributions, :address_zip, :string
    add_column    :monetary_contributions, :address_state, :string
    add_column    :monetary_contributions, :receiver_id, :string
  end
end
