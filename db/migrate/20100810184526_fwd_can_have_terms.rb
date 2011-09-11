class FwdCanHaveTerms < ActiveRecord::Migration
  def self.up
    add_column :extra_folder_with_downloadables_fields, :terms_and_conditions_id, :integer
  end

  def self.down
  end
end
