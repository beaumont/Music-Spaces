# == Schema Information
# Schema version: 20090211222143
#
# Table name: extra_folder_with_downloadables_fields
#
#  id                       :integer(11)     not null, primary key
#  folder_id                :integer(11)
#  require_terms_acceptance :boolean(1)
#  number_of_tracks         :string(255)
#  terms_db_store_id        :integer(11)
#  terms_db_store_ru_id     :integer(11)
#  preset_terms_and_conditions_id  :integer(11)
#  created_at               :datetime
#  updated_at               :datetime
#

#TODO: remove terms_and_conditions fields from here
class ExtraFieldset::FolderWithDownloadables < ActiveRecord::Base
  set_table_name 'extra_folder_with_downloadables_fields'
  belongs_to :folder_with_downloadables, :foreign_key => 'folder_id'
  belongs_to :terms_and_conditions
  has_many :terms_acceptances, :as => :termable

  delegate :terms, :to => :terms_and_conditions

  def display_terms_and_conditions
    return terms_and_conditions if terms_and_conditions
    TermsAndConditions.new
  end

  def require_terms_acceptance?
    terms_and_conditions && terms_and_conditions.require_terms_acceptance?
  end
  
  def need_terms_acceptance_of(user)
     require_terms_acceptance? && terms_acceptances.for_user(user).for_terms(terms_and_conditions).blank?    
  end

  def create_terms_acceptance(user, terms)
    raise Kroogi::NotFound unless terms_and_conditions == terms
    terms_acceptances.create!(:terms_and_conditions_id => terms.id, :user_id => user.id)
  end

end
