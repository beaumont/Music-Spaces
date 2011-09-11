class UpgradingTranslationDumper < ActiveRecord::Migration
  def self.up
    add_column :translation_schema, :model, :string
    TranslationSchema.find(:all, :conditions => {:model => nil}).each{|x| x.destroy}
  end

  def self.down
    remove_column :translation_schema, :model
  end
end
