module ActsAsPermitted

  module ModelExtensions
    def self.included( recipient )
      recipient.extend( ClassMethods )
    end
    
    module ClassMethods
      def acts_as_permitted
        # has_many :favorites, :as => :favorable, :order => 'created_at desc'
        include ActsAsPermitted::ModelExtensions::InstanceMethods
      end 
    end
    
    module InstanceMethods
      # to be overriden
      def is_view_permitted?(user_or_project = nil) 
          true
      end
      
      # to be overriden
      def restriction_level
         0
      end
      
      protected
      
        
    end
  end
end