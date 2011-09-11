class IndexMonetaryProcessorAccounts < ActiveRecord::Migration
  def self.up
    begin
      add_index :monetary_processor_accounts, [:account_setting_id, :verified_at], :name => 'index_mpas_on_account_setting_id_and_verified_at'
    rescue => e
      #I know I did it on Prod
      puts "couldn't create index - probably it exist already: %s" % e
    end
  end

  def self.down
  end
end
