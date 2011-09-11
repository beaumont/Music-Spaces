class HomogenizeMonetaryProcessorName < ActiveRecord::Migration
  def self.up
    rename_column :monetary_transactions, :processor_id,      :monetary_processor_id
    rename_column :monetary_transactions, :processor_log,     :monetary_processor_log
    rename_column :monetary_transactions, :processor_fee_usd, :monetary_processor_fee_usd
  end

  def self.down
    rename_column :monetary_transactions, :monetary_processor_id,      :processor_id
    rename_column :monetary_transactions, :monetary_processor_log,     :processor_log
    rename_column :monetary_transactions, :monetary_processor_fee_usd, :processor_fee_usd
  end
end
