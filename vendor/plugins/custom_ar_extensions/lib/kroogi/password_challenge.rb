module Kroogi
  module PasswordChallenge
    module ClassMethods
      def password_required_for(*pass_fields)
        fields_string = pass_fields.collect{|f| ":#{f}"}.join(',')
        class_eval(<<-EOS, __FILE__, __LINE__ + 1)
          attr_accessor :password_validated
          
          def password_validated?
            !!password_validated
          end
          
          def self.password_validated_fields
            [#{fields_string}]
          end
          
          def password_validated_fields
            self.class.password_validated_fields
          end
          
          def skip_password_validation?(attrib, value)
            false
          end
          
          validates_each(*password_validated_fields) do |record,attrib,value|
            unless record.skip_password_validation?(attrib, value)
              conditions_met = (record.send("\#{attrib}_changed?") && !record.send("\#{attrib}_change").all?(&:blank?) ) && !record.password_validated? && !record.new_record? && first
              if conditions_met
                record.errors.add(attrib, "requires your Kroogi password in order to be changed.".t) if record.errors.blank?
              end
            end
          end
          
          def validate_password(user_to_validate,pass)
            self.password_validated = user_to_validate.authenticated?(pass) #&& self.try(:user, self).is_self_or_owner?(user_to_validate)
            # self.errors.add_to_base("The password you entered is invalid!".t) unless self.password_validated?
          end
          
          
        EOS
      end
    end
  
    def self.included(receiver)
      receiver.extend         ClassMethods
    end
  end  
end
