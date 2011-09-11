class RefactorContentsOriginalOwners < ActiveRecord::Migration
  def self.up
    create_table "content_import_details", :force => true do |t|
      t.with_options(:null => false) do |tt|
        tt.integer :original_content_id
        tt.integer :previous_content_id
        tt.integer :previous_owner_id
        tt.integer :inbox_id
        tt.integer :content_id, :null => true
        tt.integer :new_owner_id
      end
    end
    add_index "content_import_details", ["content_id"], :name => "content_import_details_unique_content_id", :unique => true
    add_index "content_import_details", ["original_content_id"], :name => "content_import_details_original_content_id"

    contents = Content.find(:all, :conditions => 'original_owner is not null', :order => 'id asc')
    count = contents.count
    idx = 0
    created = 0
    contents.each do |c|
      idx += 1
      puts "processing #{idx} of #{count}" if idx % 100 == 0
      new_content_id = c.id
      original_content_id = c.original_owner.split(':')[1]
      c.original_owner.split(';').reverse.each do |old_import|
        prev_owner_id, prev_content_id, inbox_id, new_owner_id = old_import.split(':')
        unless ContentImportDetails.find_by_content_id(new_content_id)
          cid = ContentImportDetails.new(:original_content_id => original_content_id,
                                       :previous_content_id => prev_content_id, :previous_owner_id => prev_owner_id,
                                       :inbox_id => inbox_id, :content_id => new_content_id,
                                       :new_owner_id => new_owner_id)
          prev_content = Content.find_by_id(prev_content_id)
          if prev_content && prev_content.user_id != prev_owner_id.to_i
            cid.previous_owner_id = prev_content.user_id
            pu = User.find(prev_owner_id)
            nu = User.find(cid.previous_owner_id)
            puts "Import %s: corrected previous owner id from %s %s to %s %s" % [cid.inspect, pu.class.name, pu.login,
                                                                                 nu.class.name, nu.login]
          end
          if c.user_id != new_owner_id.to_i
            cid.new_owner_id = c.user_id
            pu = User.find(new_owner_id)
            nu = User.find(cid.new_owner_id)
            puts "Import %s: corrected new owner id from %s %s to %s %s" % [cid.inspect, pu.class.name, pu.login,
                                                                            nu.class.name, nu.login]
          end
          cid.save!
          created += 1
        end
        new_content_id = prev_content_id
      end
    end
    puts "created %s ContentImportDetails" % created
  end

  def self.down
    drop_table "content_import_details"
  end
end
