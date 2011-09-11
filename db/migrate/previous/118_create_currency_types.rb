class CreateCurrencyTypes < ActiveRecord::Migration

  def self.up
    create_table :currency_types do |t|
      t.references :accountable, :polymorphic => { :default => 'AccountSetting' }
      t.decimal :roubles, :precision => 10, :scale => 2
      t.decimal :euros, :precision => 10, :scale => 2
      t.decimal :dollars, :precision => 10, :scale => 2
      t.timestamps
    end
    transaction do
      Invite.find(:all, :conditions => ["price is not null"]).each do |invite|
        invite.create_currency_type({:dollars => invite.price_before_type_cast})
      end
      AccountSetting.find(:all, :conditions => {:request_status => "approved"}).each do |ac|
        ac.create_currency_type({:roubles => ac.donation_amount_wmr_before_type_cast, 
                                  :dollars => ac.donation_amount_before_type_cast, 
                                  :euros => ac.donation_amount_wme_before_type_cast})
      end
      UserKroog.find(:all, :conditions => ["price is not null"]).each do |uk|
        uk.create_currency_type({:dollars => uk.price_before_type_cast})        
      end
    end
  end

  def self.down
    drop_table :currency_types
  end
end
