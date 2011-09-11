class OnlyOneUserPerEmail < ActiveRecord::Migration
  def self.up

    # This won't do any harm if it's already been run, but it will be replaced with a much better structure soon.
    # In order to avoid any future frustrating trying to manually deal with the duplicate emails from here, I'm
    # just commenting it out.
    
    # If you do find yourself migrating from scratch somewhere, it's safe to ignore this mirgration entirely.

    # dup_emails = User.find_by_sql('select *, COUNT(id) as cnt from users where type="User" group by email having cnt > 1').map(&:email)
    # bad_emails = []
    # dup_emails.each do |eml|
    #   # If it's not gmail or already has a plus, error out
    #   unless (eml.match(/gmail.com/i) || eml.match(/your-net-works.com/i) || eml.match(/bigmig.com/i) || eml.match(/gnsi-inc.com/i)) && !eml.match(/\+/)
    #     bad_emails << eml
    #     next
    #   end
    #   
    #   # Else, change email@gmail.com to email+1, email+2, etc at gmail.com
    #   all_with_email = User.find(:all, :conditions => {:type => 'User', :email => eml})
    #   all_with_email.each_with_index do |user, idx|
    #     user.update_attribute(:email, user.email.sub('@', "+#{idx}@"))
    #   end
    # end
    # 
    # unless bad_emails.empty?
    #   AdminNotifier.deliver_alert("Duplicate user emails preventing OnlyOneUserPerEmail migration from completing: #{bad_emails.join(', ')}")
    #   raise "Duplicate user emails preventing OnlyOneUserPerEmail migration from completing: #{bad_emails.join(', ')}"
    # end
  end

  def self.down
  end
end
