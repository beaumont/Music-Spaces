class ContestHasTerms < ActiveRecord::Migration
  def self.up
    add_column 'music_contest_details', :terms_and_conditions_id, :integer
  end

  def self.down
  end
end
