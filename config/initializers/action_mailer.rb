# makes ActionMailer.helper work the same as ActionController.helper
module ModifiedHelper
  def helper(*args, &block)
    args.flatten.each do |arg|
      case arg
        when Module
          add_template_helper(arg)
        when :all
          helper(ActionController::Base.__send__(:all_application_helpers))
        when String, Symbol
          file_name  = arg.to_s.underscore + '_helper'
          class_name = file_name.camelize

          begin
            require_dependency(file_name)
          rescue LoadError => load_error
            requiree = / -- (.*?)(\.rb)?$/.match(load_error.message).to_a[1]
            if requiree == file_name
              msg = "Missing helper file helpers/#{file_name}.rb"
              raise LoadError.new(msg).copy_blame!(load_error)
            else
              raise
            end
          end

          add_template_helper(class_name.constantize)
        else
          raise ArgumentError, "helper expects String, Symbol, or Module argument (was: #{args.inspect})"
      end
    end

    # Evaluate block in template class if given.
    master_helper_module.module_eval(&block) if block_given?
  end    
end
ActionMailer::Base.extend(ModifiedHelper)
