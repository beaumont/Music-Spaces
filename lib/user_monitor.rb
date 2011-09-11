module ActiveRecord
    module UserMonitor
        def self.included(base)
            base.class_eval do
                alias_method_chain :create, :user
                alias_method_chain :update, :user
                attr_internal_accessor :skip_monitor
                # protected(:skip_monitor)
                
                def current_user
                    Thread.current['user']
                end
                def current_actor
                    if current_user
                        current_user.actor
                    else
                        nil
                    end
                end
                
                # disable the monitoring methods for all the code within a block
                # object.do_stuff # monitoring is on
                # object.without_monitoring do
                #  object.do_stuff # do stuff without monitoring
                # end
                # object.do_stuff # monitoring is on
                # this may be used in the application
                # it will return the result of the block
                def without_monitoring
                    begin
                      @_skip_monitor = true
                      resp = yield
                    ensure
                      @_skip_monitor = false
                      resp
                    end
                end

                  
                # same thing at the class level
                def self.without_monitoring
                    begin
                      class_eval "def skip_monitor() true end", __FILE__, __LINE__ 
                      resp = yield
                    ensure
                      class_eval "def skip_monitor() @_skip_monitor end", __FILE__, __LINE__
                      resp
                    end
                end
            end
        end
        
        def create_with_user
            if respond_to?(:created_by_id) && !skip_monitor
                user = current_user # do not except guest user :created_by_id is not nullable
                raise Kroogi::Error, "no current_user in user_monitor.rb" unless user
                self[:created_by_id] = user.id if respond_to?(:created_by_id) && (created_by_id.nil? || created_by_id == 0)
                self[:author_id] = (user.actor || user).id if respond_to?(:author_id) && (author_id.nil? || author_id == 0)
                self[:updated_by_id] = user.id if respond_to?(:updated_by_id)
            end
            create_without_user
        end

        def update_with_user
            if respond_to?(:updated_by_id) && !skip_monitor
                user = current_user
                self[:updated_by_id] = user.id if respond_to?(:updated_by_id) && !user.nil?
            end
            update_without_user
        end
        
        def created_by
          User.find_by_id(self[:created_by_id])
        end

        def updated_by
          User.find_by_id(self[:updated_by_id])
        end
    end
end