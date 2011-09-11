class CreateFeedEntriesArchive < ActiveRecord::Migration
  def self.up
    create_table "feed_entries_archive", :force => true do |t|
      t.column "to_user_id",       :integer,                     :null => false
      t.column "content_category", :integer
      t.column "from_collections", :boolean,  :default => false, :null => false
      t.column "created_at",       :datetime
      t.column "updated_at",       :datetime
    end

    create_table "feed_entry_activities_archive", :force => true do |t|
      t.column "feed_entry_id",    :integer, :null => false
      t.column "activity_type_id", :integer
      t.column "content_id",       :integer
      t.column "content_type",     :string
      t.column "activity_id",      :integer, :null => false
      t.column "position",         :integer
      t.column "from_user_id",     :integer
      t.column "to_user_id",       :integer
    end
  end

  def self.down
  end
end
