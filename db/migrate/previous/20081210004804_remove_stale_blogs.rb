class RemoveStaleBlogs < ActiveRecord::Migration
  def self.up
    Blog.find(:all, :include => :blogentry).each{|b| b.destroy if b.blogentry.nil? || b.blogentry.account.nil?}
  end

  def self.down
  end
end
