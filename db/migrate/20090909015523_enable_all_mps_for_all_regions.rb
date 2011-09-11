class EnableAllMpsForAllRegions < ActiveRecord::Migration
  def self.up
    execute "update monetary_processors set allow_donations_in_regions = 'NA EU RU OTHER';"
  end

  def self.down
  end
end
