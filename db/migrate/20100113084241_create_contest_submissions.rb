class CreateContestSubmissions < ActiveRecord::Migration
  def self.up
    create_table :contest_submissions, :force => true do |t|
      t.integer :content_id
      t.integer :level, :null => false
      t.integer :created_by_id
      t.integer :updated_by_id
      t.timestamps
    end
    add_index :contest_submissions, [:content_id]
    add_index :contest_submissions, [:created_by_id]

    i = 0
    MusicContest.all.each do |mc|
      mc.album_contents.each do |c|
        next unless c.is_a?(Track)
        Thread.current['user'] = c.created_by 
        ContestSubmission.create!(:content_id => c.id, :level => 0)
        i += 1
      end
    end
    puts "%s contest submission records created" % i
  end

  def self.down
  end
end
