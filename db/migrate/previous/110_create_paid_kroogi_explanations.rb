class CreatePaidKroogiExplanations < ActiveRecord::Migration
  def self.up
    begin
      PaidKroogiExplanation.transaction do
        add_column :preferences, :paid_kroogi_explanation_id, :integer
        create_table :paid_kroogi_explanations do |t|
          t.text :explanation
          t.boolean :custom, :default => false
          t.timestamps
        end
        add_index :paid_kroogi_explanations, :custom

        explans = [
          "Please donate... otherwise I'll have to start waiting tables, and that's gonna affect my music",
        ]

        explans.each do |explan|
          e = PaidKroogiExplanation.new(:explanation => explan)
          if e.update_attribute(:custom, false)
            puts "Created explanation: #{explan[0..40]}..."
          else puts "*\t ERROR creating explanation: #{explan[0..40]}..."
          end
        end
        PaidKroogiExplanation.update_all 'custom = 0'
      end
    rescue NameError # Migrating after class has been removed...

    end
  end

  def self.down
    begin
      PaidKroogiExplanation
      drop_table :paid_kroogi_explanations
      remove_column :preferences, :paid_kroogi_explanation_id
    rescue NameError
    end
  end
end
