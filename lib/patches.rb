module ActiveRecord
  module Validations
    module ClassMethods
      def validates_uniqueness_of(*attr_names)
        configuration = { :message => ActiveRecord::Errors.default_error_messages[:taken], :case_sensitive => true }
        configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)

        validates_each(attr_names,configuration) do |record, attr_name, value|
          if value.nil? || (configuration[:case_sensitive] || !columns_hash[attr_name.to_s].text?)
            condition_sql = "#{record.class.table_name}.#{attr_name} #{attribute_condition(value)}"
            condition_params = [value]
          else
            condition_sql = "LOWER(#{record.class.table_name}.#{attr_name}) #{attribute_condition(value)}"
            condition_params = [value.downcase]
          end
          if scope = configuration[:scope]
            Array(scope).map do |scope_item|
              scope_value = record.send(scope_item)
              condition_sql << " AND #{record.class.table_name}.#{scope_item} #{attribute_condition(scope_value)}"
              condition_params << scope_value
            end
          end
          unless record.new_record?
            condition_sql << " AND #{record.class.table_name}.#{record.class.primary_key} <> ?"
            condition_params << record.send(:id)
          end
          #find_with_class = configuration[:ignore_sti] ? record.class.base_class : record.class
          if record.class.base_class.find(:first, :conditions => [condition_sql, *condition_params])
            record.errors.add(attr_name, configuration[:message])
          end
          # if record.class.find(:first, :conditions => [condition_sql, *condition_params])
          #             record.errors.add(attr_name, configuration[:message])
          #           end
          
          # records = find(:all, :conditions => [condition_sql, *condition_params]) 
          #             record.errors.add(attr_name, configuration[:message]) if records.size > 0 and records[0].id != record.id 
          #           end
        end
      end
    end
  end
end

module ActionController #:nodoc:
  class CgiRequest
    private
    def session_options_with_string_keys
      if @session_options[:session_domain].nil? && self.domain != 'localhost'
        #puts "fixing session options to be not stupid with domain: #{self.domain}"
        @session_options[:session_domain] = self.domain
      end
      @session_options_with_string_keys ||= DEFAULT_SESSION_OPTIONS.merge(@session_options).stringify_keys
    end
  end
end