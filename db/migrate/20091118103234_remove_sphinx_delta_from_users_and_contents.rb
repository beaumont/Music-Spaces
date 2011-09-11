class RemoveSphinxDeltaFromUsersAndContents < ActiveRecord::Migration
  def self.up
    no_need = ActiveRecord::Base.connection.select_rows("select * from schema_migrations where version = '20091109225024'").blank?
    if no_need
      puts "no deltas - no need to remove"
      return
    end
    remove_index :contents, :delta
    remove_column :contents, :delta

    remove_index :users, :delta
    remove_column :users, :delta
  end

  def self.down
  end
end
