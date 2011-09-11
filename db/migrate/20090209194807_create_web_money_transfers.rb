class CreateWebMoneyTransfers < ActiveRecord::Migration
  def self.up
    create_table :web_money_transfers do |t|
      t.string  :receiver_account_setting_id, :sender_account_setting_id
      t.string  :source_wmid, :destination_wmid
      t.integer :purse_type
      t.string  :amount
      t.boolean :success
      t.text    :response
      t.timestamps
    end
    
    # change current increment based on environment
    offset = case RAILS_ENV
      when 'development':
        50_000
      when 'staging':
        100_000
      when 'rc':
        250_000
      when 'production':
        5_000_000
      else raise NotImplemented      
    end
    WebMoneyTransfer.connection.execute("ALTER TABLE web_money_transfers AUTO_INCREMENT = #{offset}")
    
  end

  def self.down
    drop_table :web_money_transfers
  end
end
