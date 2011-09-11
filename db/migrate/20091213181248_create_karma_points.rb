class CreateKarmaPoints < ActiveRecord::Migration
  def self.up
    create_table :karma_points do |t|
      t.integer :referrer_id              # user reference
      t.integer :content_id               # content reference
      t.integer :monetary_donation_id     # the donation reference
      t.string  :referral_url             # where the link was posted
      t.timestamps
    end
    add_index :karma_points, [:referrer_id, :content_id], :name => "karma_lookup"
  end

  def self.down
    remove_index :karma_points, :name => :index_name
    remove_index :karma_points, :name => :karma_lookup
    drop_table :karma_points
  end
end
