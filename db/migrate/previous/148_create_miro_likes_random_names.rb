class CreateMiroLikesRandomNames < ActiveRecord::Migration
  class MiroLikesRandomNames < ActiveRecord::Base
    set_table_name :admission_pass_name_list
  end
  
  def self.up
    create_table :admission_pass_name_list do |t|
      t.string :name
    end
    add_column :monetary_contributions, :event_access_key, :string
    names_file = %{#{RAILS_ROOT}/db/data/access_names.txt}
    if File.exist?(names_file)
      File.open(names_file).each{ |line| MiroLikesRandomNames.create({:name => line.chomp}) }
    end
  end

  def self.down
    remove_column :monetary_contributions, :event_access_key
    drop_table :admission_pass_name_list
  end
end
