#
#  create_table "terms_and_conditions", :force => true do |t|
#    t.column "require_terms_acceptance", :boolean
#    t.column "terms_db_store_id",        :integer
#    t.column "terms_db_store_ru_id",     :integer
#    t.column "created_at",               :datetime
#    t.column "updated_at",               :datetime
#    t.column "created_by_id",            :integer
#    t.column "updated_by_id",            :integer
#  end
#

class TermsAndConditions < ActiveRecord::Base
  translates_virtual_attribute :terms

  def initialize(params = {})
    preset = params.delete(:preset)
    if preset
      preset = PresetTermsAndConditions.first
      super(:_terms => preset._body, :terms_ru => preset.body_ru) if preset 
    else
      super(params)
    end
  end

  def self.create_or_update!(params, client_object)
    if params
      terms = client_object.terms_and_conditions
      self.transaction do
        unless terms
          terms = self.new
        end
        terms.update_attributes!(params)
        client_object.terms_and_conditions = terms
        client_object.save!
      end
    end    
  end
  
end
