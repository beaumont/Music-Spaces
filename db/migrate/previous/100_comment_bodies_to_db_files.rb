class CommentBodiesToDbFiles < ActiveRecord::Migration
  def self.up
    create_table "db_store", :options => 'TYPE=InnoDB', :force => true do |t|
      t.text :content
    end
    add_column :comments, :db_store_id, :integer
    
    # Get comments via SQL, model has changed
    comments = ActiveRecord::Base.connection.execute('select id, comment from comments')

    # Save comments. Bizarre error (wrong num args), so just doing it by hand
    db_id = 1
    comments.each_hash do |row| 
      ActiveRecord::Base.connection.execute("INSERT INTO db_store (id, content) VALUES (#{db_id}, #{DbStore.quote_value(row['comment'])})")
      ActiveRecord::Base.connection.execute("UPDATE comments SET db_store_id = #{db_id} where id = #{row['id']}")
      db_id += 1
    end

    # It's all good, remove the comment field
    remove_column :comments, :comment
  end

  def self.down
    $stdout.print "You will lose all existing comment bodies unless you've editing the comment model to store comments in the comment column of the comments table again.\nContinue? (y/n): "
    $stdout.flush
    raise "Fix the model first, then come back" unless $stdin.gets =~ /y/i
    
    # Update database
    add_column :comments, :comment, :text

    dcomments = ActiveRecord::Base.connection.execute('select id, db_store_id from comments')
    dcomments.each_hash do |row|
      if comment = Comment.find_by_id(row['id'])
        db = DbStore.find(row['db_store_id'])
        ActiveRecord::Base.connection.execute("UPDATE comments SET comment = #{Comment.quote_value(db.content)} where id = #{row['id']}")
      else say "Missing comment #{row['id']}"
      end
    end
    
    drop_table :db_store    
    remove_column :comments, :db_store_id
  end
end
