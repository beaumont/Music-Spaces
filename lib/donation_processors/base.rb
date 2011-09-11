module DonationProcessors
  module Base
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def in_successful_payment_handler?(controller)
        #we cannot add POST check here because at least in Smscoin case it's GET
        return (controller.params[:payment_status] == "Completed")
      end
    end
  end
end
