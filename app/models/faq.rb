# == Schema Information
# Schema version: 20081006211752
#
# Table name: faqs
#
#  id          :integer(11)     not null, primary key
#  question    :string(255)
#  answer      :text
#  created_at  :datetime
#  updated_at  :datetime
#  question_ru :string(255)
#  answer_ru   :text
#

class Faq < ActiveRecord::Base
  xss_terminate :except => [:answer]
  translates :question, :answer
  
  # Return a random FAQ
  def self.random
    Faq.find(:first, :order => 'rand()')
  end
  
end
