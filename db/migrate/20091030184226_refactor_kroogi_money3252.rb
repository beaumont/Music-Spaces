class RefactorKroogiMoney3252 < ActiveRecord::Migration
  def self.up
    km_user = User.find_by_login('kroogi-money')
    return unless km_user
    
    #1. disable circle "pending request" (which was 2 - so we'll have only 1 and 5 left).
    Relationship.destroy_all(:user_id => km_user.id, :relationshiptype_id => 2)
    km_user.preference.update_attribute(:active_circle_ids, [1, 5])

    #2. remove all users from circle "hooked up". 
    Relationship.destroy_all(:user_id => km_user.id, :relationshiptype_id => 1)

    #3. add all users who can receive contributions to circle "hooked up"
    conditions = {:conditions => ["state = 'verified' and deleted_at IS NULL"]}
    count = MonetaryProcessorAccount.count(conditions)
    processed = Set.new
    idx = 0
    page_size = 50
    MonetaryProcessorAccount.paginated_each(conditions.merge(:per_page => page_size, :order => 'id')) do |mpa|
      idx += 1
      if processed.include?(mpa.account_setting_id)
        puts "skipped mpa %s - its user, %s, is already processed" % [mpa.id, mpa.account_setting.user.login]
        next
      end
      if mpa.user.deleted?
        puts "skipped mpa %s - its user, %s, is deleted" % [mpa.id, mpa.account_setting.user.login]
        next
      end
      Relationship.create!(:user_id => km_user.id, :related_user_id => mpa.account_setting.user_id,
                           :relationshiptype_id => 1)
      processed << mpa.account_setting_id
      puts "Processed #{idx} users with money of #{count}" if idx % page_size == 0
    end
    puts "RefactorKroogiMoney3252: done"
  end

  def self.down
  end
end
