class CreateRelationshiptypes < ActiveRecord::Migration
  def self.up
    
    r1 = Relationshiptype.create(:name => 'Founders' , :restricted => 2, :position => 3)
    r2 = Relationshiptype.create(:name => 'Family', :restricted => 0, :position => 4)
    r3 = Relationshiptype.create(:name => 'Backstage', :restricted => 0, :position => 5)
    r4 = Relationshiptype.create(:name => 'Front row', :restricted => 0, :position => 6)
    r5 = Relationshiptype.create(:name => 'Fan club', :restricted => 0, :position => 7)
    r6 = Relationshiptype.create(:name => 'Interested', :restricted => 0, :position => 8)
    #r7 = Relationshiptype.create(:name => 'Invited', :restricted => -1, :position => 100)
    r8 = Relationshiptype.create(:name => 'Watching', :restricted => 0, :position => 9)
    r9 = Relationshiptype.create(:id => -2, :name => 'Everyone', :restricted => 1, :position => 10)
    r10 = Relationshiptype.create(:id => -1, :name => 'Nobody', :restricted => 1, :position => 2)
    
    ActiveRecord::Base.connection.execute "update relationshiptypes set id = 0 where name = '#{r1.name}'"
    ActiveRecord::Base.connection.execute "update relationshiptypes set id = 1 where name = '#{r2.name}'"
    ActiveRecord::Base.connection.execute "update relationshiptypes set id = 2 where name = '#{r3.name}'"
    ActiveRecord::Base.connection.execute "update relationshiptypes set id = 3 where name = '#{r4.name}'"
    ActiveRecord::Base.connection.execute "update relationshiptypes set id = 4 where name = '#{r5.name}'"
    ActiveRecord::Base.connection.execute "update relationshiptypes set id = 5 where name = '#{r6.name}'"
    #ActiveRecord::Base.connection.execute "update relationshiptypes set id = 6 where name = '#{r7.name}'"
    ActiveRecord::Base.connection.execute "update relationshiptypes set id = 7 where name = '#{r8.name}'"
    ActiveRecord::Base.connection.execute "update relationshiptypes set id = -2 where name = '#{r9.name}'"
    ActiveRecord::Base.connection.execute "update relationshiptypes set id = -1 where name = '#{r10.name}'"
    
  end

  def self.down
    Relationshiptype.delete_all
  end
  
end
