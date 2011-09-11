class AddPopularityToContentAndUser < ActiveRecord::Migration
  def self.up
    add_column :users, :popularity, :float, :default => 0.0 
    add_index :users,  :popularity
    add_column :contents, :popularity, :float, :default => 0.0 
    add_index  :contents, :popularity

    # Initialize popularity
    User.update_popularity( DateTime.new(1,1,1) )
    Content.update_popularity( DateTime.new(1,1,1) )
  end

  def self.down
  end
end
