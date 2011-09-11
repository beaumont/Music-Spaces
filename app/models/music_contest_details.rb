#  create_table "music_contest_details", :force => true do |t|
#    t.column "content_id",              :integer
#    t.column "second_title",            :string
#    t.column "second_title_ru",         :string
#    t.column "second_title_fr",         :string
#    t.column "start_date",              :date
#    t.column "end_date",                :date
#    t.column "accepts_submissions",     :boolean
#    t.column "created_at",              :datetime
#    t.column "updated_at",              :datetime
#    t.column "terms_and_conditions_id", :integer
#  end
#
class MusicContestDetails < ActiveRecord::Base
  translates :second_title, :base_as_default => true
  belongs_to :terms_and_conditions
  has_many :terms_acceptances, :as => :termable

  def display_terms_and_conditions
    return terms_and_conditions if terms_and_conditions
    TermsAndConditions.new(:preset => true)
  end

  def create_terms_acceptance(user, terms)
    raise Kroogi::NotFound unless terms_and_conditions == terms
    terms_acceptances.create!(:terms_and_conditions_id => terms.id, :user_id => user.id)
  end

  def need_terms_acceptance_of(user)
    terms_and_conditions && terms_and_conditions.require_terms_acceptance? &&
            terms_acceptances.for_user(user).for_terms(terms_and_conditions).blank?
  end

end
