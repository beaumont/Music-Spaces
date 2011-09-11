class AddContestIdToContestSubmissions < ActiveRecord::Migration
  def self.up
    add_column :contest_submissions, :contest_id, :integer
    add_index :contest_submissions, [:contest_id]
    ContestSubmission.all.each do |cs|
      cs.update_attribute(:contest_id, cs.content.container_album.id)
    end
  end

  def self.down
  end
end
