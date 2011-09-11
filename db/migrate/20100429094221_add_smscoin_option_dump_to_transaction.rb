class AddSmscoinOptionDumpToTransaction < ActiveRecord::Migration
  def self.up
    add_column 'smscoin_transactions', 'cost_option_dump', :text
    Smscoin::Transaction.all.each do |tran|
      option = Smscoin::CostOption.find_by_id(tran.cost_option_id)
      if option
        tran.cost_option = option
        tran.save
      end
    end

    remove_column 'smscoin_transactions', 'cost_option_id'
  end

  def self.down
  end
end
