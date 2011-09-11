module ActsAsFavorite
  module Identity
  
    module UserExtensions
      module InstanceMethods

        def method_missing( method_sym, *args )
          if method_sym.to_s =~ Regexp.new("^favorite_(\\w+)")
            favorite_class = ($1).singularize.classify.constantize
            favorite_class.find(:all, :include => :favorites,
                                :conditions => ['favorites.user_id = ? AND favorites.favorable_type = ?', 
                                                id, favorite_class.to_s ] )
          elsif method_sym.to_s =~ Regexp.new("^only_favorite_(\\w+)_ids")
            favorite_class = ($1).singularize.classify.constantize
            Favorite.find(:all, :conditions => ['favorites.user_id = ? AND favorites.favorable_type = ?', 
                                                id, favorite_class.to_s ], :select => 'id, favorable_id' )
                                                
          elsif method_sym.to_s =~ Regexp.new("^has_favorite_(\\w+)\\?")
            favorite_class = ($1).singularize.classify.constantize
            Favorite.count( :include => :user, :conditions => [ 'favorites.user_id = ? AND favorites.favorable_type = ?', 
                                                                id, favorite_class.to_s ] ) != 0
          else
            super
          end
        rescue
          super
        end
        
      end
    end
    
  end
end