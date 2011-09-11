# 
# Table name: preset_terms_and_conditions
#
#  id            :integer(11)     not null, primary key
#  title         :string(255)
#  title_ru      :string(255)
#  body          :text
#  body_ru       :text
#  created_at    :datetime
#  updated_at    :datetime
#  created_by_id :integer(11)
#

class PresetTermsAndConditions < ActiveRecord::Base
  # This model stores the default terms and conditions for e.g. user submitted content albums
  has_many :folder_with_dl_extra_fieldsets, :class_name => ExtraFieldset::FolderWithDownloadables.name
  translates :body, :title, :base_as_default => true

  xss_terminate :except => [:body, :body_ru]

  def owning_folders
    FolderWithDownloadables.find(:all, :include => :fwd_details,
            :conditions => ['extra_folder_with_downloadables_fields.preset_terms_and_conditions_id = ?', self.id])
  end
end
