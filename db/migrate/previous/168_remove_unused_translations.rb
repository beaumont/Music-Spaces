class RemoveUnusedTranslations < ActiveRecord::Migration
  def self.up
    # Now that circle names are customizable, we don't need to store these anymore
    remove_column :relationshiptypes, :name_ru
  end

  def self.down
    add_column :relationshiptypes, :name_ru, :string
  end
end
