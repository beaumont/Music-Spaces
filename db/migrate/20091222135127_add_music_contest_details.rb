class AddMusicContestDetails < ActiveRecord::Migration
  def self.up
    create_table :music_contest_details, :force => true do |t|
      t.integer :content_id
      t.string :second_title
      t.string :second_title_ru
      t.string :second_title_fr
      t.date :start_date
      t.date :end_date
      t.boolean :accepts_submissions
      t.timestamps
    end
    add_index :music_contest_details, [:content_id], :name => "index_music_contest_details_on_content_id"
  end

  def self.down
  end
end
