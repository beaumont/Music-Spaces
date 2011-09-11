class AllowModeration < ActiveRecord::Migration
  def self.up
    r = Role.create(:name => 'moderator', :status => 1)
    raise "\n\nERROR: moderator must have ID of 4\n\n" unless r.id == 4
  end

  def self.down
    raise "\n\nMust be done manually (moderator has to have ID of 4)\n\n"
  end
end
