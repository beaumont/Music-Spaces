ActiveRecord::RecordInvalid #make sure it's loaded

module ActiveRecord
  # Raised by <tt>save!</tt> and <tt>create!</tt> when the record is invalid.  Use the
  # +record+ method to retrieve the record which did not validate.
  #   begin
  #     complex_operation_that_calls_save!_internally
  #   rescue ActiveRecord::RecordInvalid => invalid
  #     puts invalid.record.errors
  #   end
  class RecordInvalid < ActiveRecordError
    def initialize(record)
      @record = record
      super('Validation failed'.t + ": #{@record.errors.full_messages.join(", ")}")
      #super("Validation failed: #{@record.errors.full_messages.join(", ")}")
    end
  end
end