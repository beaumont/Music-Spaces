class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.belongs_to :user
      t.string :type
      t.text :message
      t.string :reportable_type
      t.integer :reportable_id
      t.integer :flag_type, :default => 0
      t.timestamps
    end
    add_index :reports, [:reportable_type, :reportable_id]
  end

  def self.down
    drop_table :reports
  end
end
