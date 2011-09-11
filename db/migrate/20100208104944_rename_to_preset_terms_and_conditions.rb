class RenameToPresetTermsAndConditions < ActiveRecord::Migration
  def self.up
    rename_table 'terms_and_conditions', 'preset_terms_and_conditions'
    rename_column 'extra_folder_with_downloadables_fields', 'terms_and_conditions_id', 'preset_terms_and_conditions_id' 
  end

  def self.down
  end
end
