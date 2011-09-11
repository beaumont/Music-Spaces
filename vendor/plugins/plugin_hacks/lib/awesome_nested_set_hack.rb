CollectiveIdea::Acts::NestedSet::InstanceMethods.module_eval do #:nodoc:
  # Check if other model is in the same scope
  def same_scope?(other)
    !acts_as_nested_set_options[:scope] ||
      self.send(scope_column_name) == other.send(scope_column_name)
  rescue TypeError
    if Array === acts_as_nested_set_options[:scope]
      acts_as_nested_set_options[:scope].any?{ |scope_col| self.send(scope_col) == other.send(scope_col) }
    end
  end
end