class FixRelatedContents < ActiveRecord::Migration
  def self.up
    execute "alter table activities change from_related from_related boolean null"
  end

  def self.down
  end
end
