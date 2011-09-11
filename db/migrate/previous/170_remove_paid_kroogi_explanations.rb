class RemovePaidKroogiExplanations < ActiveRecord::Migration
  require "#{RAILS_ROOT}/db/migrate/110_create_paid_kroogi_explanations"
  
  def self.up
    CreatePaidKroogiExplanations.down
  end

  def self.down
    CreatePaidKroogiExplanations.up
  end
end
