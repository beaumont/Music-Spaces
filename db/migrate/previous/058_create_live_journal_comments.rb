class CreateLiveJournalComments < ActiveRecord::Migration
  def self.up
    create_table :live_journal_comments do |t|
      t.integer  :account_id, :null => false
      t.integer  :comment_id, :parent_id, :journal_item_id, :poster_id
      t.string   :state, :limit => 1, :default => 'A'
      t.string   :user, :property, :subject
      t.text     :body
      t.datetime :posted_at
      t.timestamps
    end
    add_index :live_journal_comments, [:account_id, :posted_at],  :name => "lj_account_and_post_date"
    add_index :live_journal_comments, [:account_id, :comment_id], :name => "lj_comment_account_and_comment"
  end

  def self.down
    drop_table :live_journal_comments
    remove_index :live_journal_comments, :name => :lj_comment_and_post_date
    remove_index :live_journal_comments, :name => :lj_comment_account_and_comment
  end
end
