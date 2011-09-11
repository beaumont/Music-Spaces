module ActiveRecord
  module Associations
    class AssociationProxy
      private
      # fix bogus method_missing provided by rails 2.2.2
      def method_missing(method, *args)
        if load_target
          if block_given?
            @target.send(method, *args)  { |*block_args| yield(*block_args) }
          else
            @target.send(method, *args)
          end
        end
      end
    end
  end
end