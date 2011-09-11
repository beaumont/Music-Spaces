module RedHillConsulting::TransactionalMigrations::ActiveRecord
  module Migration
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def self.extended(base)
        class << base
          alias_method_chain :migrate, :transactional_migrations
        end
      end

      def non_transactional
        @non_transactional = true
      end

      def migrate_with_transactional_migrations(direction)
        if @non_transactional
          migrate_without_transactional_migrations(direction)
        else
          ActiveRecord::Base.transaction do
            migrate_without_transactional_migrations(direction)
          end
        end
      end
    end
  end
end
