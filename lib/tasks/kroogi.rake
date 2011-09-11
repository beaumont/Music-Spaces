desc 'Update Kroogi'
namespace :kroogi do
  namespace :update do
    desc 'Update Kroogi for CollectionProjects'
    task :collections => :environment do
      I18n.locale = 'en'
      CollectionProject.paginated_each(:per_page => 1000) do |user|
        user.preference.update_attribute(:active_circle_ids, user.default_circles)

        audience = UserKroog.first(:conditions => {:user_id => user.id, :relationshiptype_id => Relationshiptype.interested})
        other_circles = UserKroog.all(:conditions => {:user_id => user.id, :relationshiptype_id => Relationshiptype.by_invite_only_without_founders})

#        founders = user.circles.first(:contitions => {:relationshiptype_id => Relationshiptype.founders})
#        if founders.blank?
#          founders = UserKroog.new(:user_id => user.id, :relationshiptype_id => Relationshiptype.founders, :open => false, :open => true, :can_request_invite => false)
#          founders.without_monitoring {founders.save}
#        elsif !founders.open?
#          founders.without_monitoring {founders.update_attributes(:open => false, :open => true, :can_request_invite => false)}
#        end

        if audience.blank?
          audience = UserKroog.new(:user_id => user.id, :relationshiptype_id => Relationshiptype.interested, :_name => "Audience", :name_ru => "Зрители", :open => true, :can_request_invite => false)
          audience.without_monitoring {audience.save}
        else
          audience.without_monitoring {audience.update_attributes(:_name => "Audience", :name_ru => "Зрители", :open => true, :can_request_invite => false)}
        end

        followers = user.followers

        followers.each do |follower|
          relationship = user.relationships.first(:conditions => {:relationshiptype_id => Relationshiptype.by_invite_only_without_founders, :related_user_id => follower.id})
          relationship.update_attribute(:relationshiptype_id, Relationshiptype.interested) unless relationship.blank?
        end unless followers.blank?

        # Remove other circles
        #other_circles.map(&:destroy)
        other_circles.map {|c| c.update_attributes(:open => false, :can_request_invite => false)}

        #generate followers
        #CollectionProject.all.map {|c| AdvancedUser.active.all(:limit => "10", :order => "rand()").map{|u| Relationship.create(:user_id => c.id, :related_user_id => u.id, :relationshiptype_id => [1,4,5].rand())}}
        print "\e[32m.\e[0m"
      end
      puts "\e[32mDONE\e[0m"
    end

    desc 'Clear duplicates relationships'
    task :clear => :environment do
      I18n.locale = 'en'
      deleted = 0
      puts "be prepared for lots of multicolor dots! we got #{User.count} users!"
      User.paginated_each(:per_page => 1000, :include => :relationships) do |user|
        related_users = {}
        relationships = user.relationships
        relationships.each do |relationship|
          related_users[relationship.related_user_id] ||= []
          related_users[relationship.related_user_id] << relationship
        end unless relationships.blank?
        related_users.each do |user_id, relationships|
          next if relationships.size < 2
          relationships = relationships.sort {|v1,v2| v1.relationshiptype_id <=> v2.relationshiptype_id}
          relationships.delete(relationships.first)
          relationships.map(&:destroy)
          deleted += relationships.size
          print "\e[31m.\e[0m"
        end
        print "\e[3#{[2,3,4,5].rand}m.\e[0m"
      end
      puts "\e[32mDONE\e[0m. removed #{deleted} dupe relationships"
    end

    desc 'Update Kroogi for BasicUsers'
    task :basic_users => :environment do
      I18n.locale = 'en'
      puts "gonna process #{BasicUser.count} basic users"
      BasicUser.paginated_each(:per_page => 1000) do |user|
        user.preference.update_attribute(:active_circle_ids, BasicUser.default_circles)

        audience_circle = UserKroog.first(:conditions => {:user_id => user.id, :relationshiptype_id => Relationshiptype.interested})

        if !audience_circle
          audience_circle = UserKroog.new(:user_id => user.id, :relationshiptype_id => Relationshiptype.interested, :_name => "Interested", :name_ru => "Знакомые", :open => true, :can_request_invite => false)
          audience_circle.without_monitoring {audience_circle.save}
        else
          audience_circle.without_monitoring {audience_circle.update_attributes(:_name => "Interested", :name_ru => "Знакомые", :open => true, :can_request_invite => false)}
        end

        followers = user.followers

        followers.each do |follower|
          relationship = user.relationships.first(:conditions => {:relationshiptype_id => Relationshiptype.by_invite_only_without_founders, :related_user_id => follower.id})
          relationship.update_attribute(:relationshiptype_id, Relationshiptype.interested) if relationship
          print "\e[33m.\e[0m"
        end unless followers.blank?

        friends_circle = UserKroog.first(:conditions => {:user_id => user.id, :relationshiptype_id => Relationshiptype.friends})

        if !friends_circle
          friends_circle = UserKroog.new(:user_id => user.id, :relationshiptype_id => Relationshiptype.friends, :_name => "Friends", :name_ru => "Друзья", :open => false, :can_request_invite => true)
          friends_circle.without_monitoring {friends_circle.save}
        else
          friends_circle.without_monitoring {friends_circle.update_attributes(:_name => "Friends", :name_ru => "Друзья", :open => false, :can_request_invite => true)}
        end

        family_circle = UserKroog.first(:conditions => {:user_id => user.id, :relationshiptype_id => Relationshiptype.family})

        if !family_circle
          family_circle = UserKroog.new(:user_id => user.id, :relationshiptype_id => Relationshiptype.family, :_name => "Family", :name_ru => "Семья", :open => false, :can_request_invite => false)
          family_circle.without_monitoring {family_circle.save}
        else
          family_circle.without_monitoring {family_circle.update_attributes(:_name => "Family", :name_ru => "Семья", :open => false, :can_request_invite => false)}
        end

        other_circles = UserKroog.all(:conditions => {:user_id => user.id, :relationshiptype_id => Relationshiptype.all_valid - BasicUser.default_circles})

        other_circles.each do |circle|
          circle.without_monitoring {circle.update_attributes(:open => false, :can_request_invite => false)}
        end unless other_circles.blank?
        print "\e[32m.\e[0m"
      end
      puts "\e[32mDONE\e[0m"
    end

    desc 'Update Kroogi for AdvencedUsers'
    task :advenced_users => :environment do
      I18n.locale = 'en'
      progress_log = Logger.new('/home/sasha/kroogi_update_advenced_users.log')
      puts "gonna process #{AdvancedUser.count} advanced users"
      i = 0
      AdvancedUser.paginated_each(:per_page => 1000) do |user|
        i += 1
        preference = user.preference

        audience = UserKroog.first(:conditions => {:user_id => user.id, :relationshiptype_id => Relationshiptype.interested})

        if audience.blank?
          audience = UserKroog.new(:user_id => user.id, :relationshiptype_id => Relationshiptype.interested, :_name => "Interested", :name_ru => "Знакомые", :open => true, :can_request_invite => false)
          audience.without_monitoring {audience.save}
        else
          audience.without_monitoring {audience.update_attributes(:_name => "Interested", :name_ru => "Знакомые", :open => true, :can_request_invite => false)}
        end

        friends = UserKroog.first(:conditions => {:user_id => user.id, :relationshiptype_id => Relationshiptype.friends})

        if friends.blank?
          friends = UserKroog.new(:user_id => user.id, :relationshiptype_id => Relationshiptype.friends, :_name => "Friends", :name_ru => "Друзья", :open => false, :can_request_invite => true)
          friends.without_monitoring {friends.save}
        else
          friends.without_monitoring {friends.update_attributes(:_name => "Friends", :name_ru => "Друзья", :open => false, :can_request_invite => true)}
        end

        family = UserKroog.first(:conditions => {:user_id => user.id, :relationshiptype_id => Relationshiptype.family})

        if family.blank?
          family = UserKroog.new(:user_id => user.id, :relationshiptype_id => Relationshiptype.family, :_name => "Family", :name_ru => "Семья", :open => false, :can_request_invite => false)
          family.without_monitoring {family.save}
        else
          family.without_monitoring {family.update_attributes(:_name => "Family", :name_ru => "Семья", :open => false, :can_request_invite => false)}
        end

        others = UserKroog.all(:conditions => {:user_id => user.id, :relationshiptype_id => Relationshiptype.all_valid - AdvancedUser.default_circles})

        others.each do |other|
          other.without_monitoring {other.update_attributes(:open => false, :can_request_invite => false)}
        end unless others.blank?

        followers = user.followers

        circles = preference.active_circle_ids.sort

        followers.each do |follower|
          relationship = user.relationships.first(:conditions => {:relationshiptype_id => Relationshiptype.by_invite_only, :related_user_id => follower.id})
          next if relationship.blank?

          if circles.size == 1
            relationship.update_attribute(:relationshiptype_id, Relationshiptype.interested)
          elsif circles.size == 2
            if circles.first == relationship.relationshiptype_id
              relationship.update_attribute(:relationshiptype_id, Relationshiptype.friends)
            else
              relationship.update_attribute(:relationshiptype_id, Relationshiptype.interested)
            end
          elsif circles.size >= 3
            if circles.first == relationship.relationshiptype_id
              relationship.update_attribute(:relationshiptype_id, Relationshiptype.family)
            elsif circles.last == relationship.relationshiptype_id
              relationship.update_attribute(:relationshiptype_id, Relationshiptype.interested)
            else
              relationship.update_attribute(:relationshiptype_id, Relationshiptype.friends)
            end
          end
          print "\e[33m.\e[0m"
        end unless followers.blank?

        preference.update_attribute(:active_circle_ids, AdvancedUser.default_circles)
        progress_log.debug "last processed user is #{user.id}" if i % 100 == 0
        print "\e[34m.\e[0m"
      end
      puts "\e[32mDONE\e[0m"
    end

    desc 'Update Kroogi for Projects'
    task :projects => :environment do
      I18n.locale = 'en'
      progress_log = Logger.new('/home/sasha/kroogi_update_projects.log')
      puts "gonna process #{Project.count} projects"
      i = 0
      Project.paginated_each(:per_page => 1000) do |user|
        i += 1
        preference = user.preference

        audience = UserKroog.first(:conditions => {:user_id => user.id, :relationshiptype_id => Relationshiptype.interested})

        if audience.blank?
          audience = UserKroog.new(:user_id => user.id, :relationshiptype_id => Relationshiptype.interested, :_name => "Audience", :name_ru => "Зрители", :open => true, :can_request_invite => false)
          audience.without_monitoring {audience.save}
        else
          audience.without_monitoring {audience.update_attributes(:_name => "Audience", :name_ru => "Зрители", :open => true, :can_request_invite => false)}
        end

        fanclub = UserKroog.first(:conditions => {:user_id => user.id, :relationshiptype_id => Relationshiptype.fanclub})

        if fanclub.blank?
          fanclub = UserKroog.new(:user_id => user.id, :relationshiptype_id => Relationshiptype.fanclub, :_name => "Fan Club", :name_ru => "Ценители", :open => false, :can_request_invite => true)
          fanclub.without_monitoring {fanclub.save}
        else
          fanclub.without_monitoring {fanclub.update_attributes(:_name => "Fan Club", :name_ru => "Ценители", :open => false, :can_request_invite => true)}
        end

        family = UserKroog.first(:conditions => {:user_id => user.id, :relationshiptype_id => Relationshiptype.family})

        if family.blank?
          family = UserKroog.new(:user_id => user.id, :relationshiptype_id => Relationshiptype.family, :_name => "Studio", :name_ru => "Студия", :open => false, :can_request_invite => false)
          family.without_monitoring {family.save}
        else
          family.without_monitoring {family.update_attributes(:_name => "Studio", :name_ru => "Студия", :open => false, :can_request_invite => false)}
        end

        others = UserKroog.all(:conditions => {:user_id => user.id, :relationshiptype_id => Relationshiptype.all_valid - Project.default_circles})

        others.each do |other|
          other.without_monitoring {other.update_attributes(:open => false, :can_request_invite => false)}
        end unless others.blank?

        followers = user.followers

        circles = preference.active_circle_ids.sort

        followers.each do |follower|
          relationship = user.relationships.first(:conditions => {:relationshiptype_id => Relationshiptype.by_invite_only, :related_user_id => follower.id})
          next if relationship.blank?

          if circles.size == 1
            relationship.update_attribute(:relationshiptype_id, Relationshiptype.interested)
          elsif circles.size == 2
            if circles.first == relationship.relationshiptype_id
              relationship.update_attribute(:relationshiptype_id, Relationshiptype.fanclub)
            else
              relationship.update_attribute(:relationshiptype_id, Relationshiptype.interested)
            end
          elsif circles.size >= 3
            if circles.first == relationship.relationshiptype_id
              relationship.update_attribute(:relationshiptype_id, Relationshiptype.family)
            elsif circles.last == relationship.relationshiptype_id
              relationship.update_attribute(:relationshiptype_id, Relationshiptype.interested)
            else
              relationship.update_attribute(:relationshiptype_id, Relationshiptype.fanclub)
            end
          end
          print "\e[33m.\e[0m"
        end unless followers.blank?

        preference.update_attribute(:active_circle_ids, Project.default_circles)
        print "\e[34m.\e[0m"
        progress_log.debug "last processed project is #{user.id}" if i % 100 == 0
      end
      puts "\e[32mDONE\e[0m"
    end

    task :friendship => :environment do
      I18n.locale = 'en'
      conditions = {:conditions => ['id >= 15982 and type in (?)', ['AdvancedUser', 'BasicUser']]}
      progress_log = Logger.new('/home/sasha/kroogi_update_friendship.log')
      puts "gonna process #{User.count(conditions)} users"
      i = 0
      User.paginated_each(conditions.merge(:per_page => 1000)) do |user|
        i += 1
        followers = user.followers

        followers.each do |follower|
          next if follower.is_a?(Project)
          user_relationship = user.relationships.first(:conditions => {:related_user_id => follower.id})

          follower_relationship = follower.relationships.first(:conditions => {:related_user_id => user.id})

          if [user_relationship, follower_relationship].any?(&:blank?)
            relationship = user_relationship || follower_relationship
            next if relationship.relationshiptype_id == Relationshiptype.interested

            if user_relationship.blank?
              user.relationships.create({:related_user_id => follower.id, :relationshiptype_id => relationship.relationshiptype_id})
            else
              follower.relationships.create({:related_user_id => user.id, :relationshiptype_id => relationship.relationshiptype_id})
            end
            print "\e[33m.\e[0m"
          else
            types = [user_relationship, follower_relationship].map(&:relationshiptype_id)
            next if types.uniq.size == 1
            type = types.sort.first
            [user_relationship, follower_relationship].map {|r| r.update_attribute(:relationshiptype_id, type)}
            print "\e[34m.\e[0m"
          end
        end
        progress_log.debug "last processed user is #{user.id}" if i % 100 == 0
      end
      puts "\e[32mDONE\e[0m"
    end

    desc 'Fix kroogi names for AdvencedUsers'
    namespace :advenced_users do
      task :fix => :environment do
        I18n.locale = 'en'
        progress_log = Logger.new('log/kroogi_advenced_users_fix.log')
        puts "gonna process #{AdvancedUser.count} advanced users"
        i = 0
        AdvancedUser.paginated_each(:per_page => 1000) do |user|
          i += 1

          audience = UserKroog.first(:conditions => {:user_id => user.id, :relationshiptype_id => Relationshiptype.interested})
          audience.without_monitoring {audience.update_attributes(:_name => "Interested", :name_ru => "Знакомые", :open => true, :can_request_invite => false)}

          friends = UserKroog.first(:conditions => {:user_id => user.id, :relationshiptype_id => Relationshiptype.friends})
          friends.without_monitoring {friends.update_attributes(:_name => "Friends", :name_ru => "Друзья", :open => false, :can_request_invite => true)}


          family = UserKroog.first(:conditions => {:user_id => user.id, :relationshiptype_id => Relationshiptype.family})
          family.without_monitoring {family.update_attributes(:_name => "Family", :name_ru => "Семья", :open => false, :can_request_invite => false)}

          progress_log.debug "last processed user is #{user.id}" if i % 100 == 0
          print "\e[34m.\e[0m"
        end
        puts "\e[32mDONE\e[0m"
      end
    end

    desc 'Fix kroogi names for Projects'
    namespace :projects do
      task :fix => :environment do
        I18n.locale = 'en'
        progress_log = Logger.new('log/kroogi_projects_fix.log')
        puts "gonna process #{Project.count} projects"
        i = 0
        Project.paginated_each(:per_page => 1000) do |user|
          i += 1

          audience = UserKroog.first(:conditions => {:user_id => user.id, :relationshiptype_id => Relationshiptype.interested})
          audience.without_monitoring {audience.update_attributes(:_name => "Audience", :name_ru => "Зрители", :open => true, :can_request_invite => false)}

          funclub = UserKroog.first(:conditions => {:user_id => user.id, :relationshiptype_id => Relationshiptype.fanclub})
          funclub.without_monitoring {funclub.update_attributes(:_name => "Fan Club", :name_ru => "Ценители", :open => false, :can_request_invite => true)}


          studio = UserKroog.first(:conditions => {:user_id => user.id, :relationshiptype_id => Relationshiptype.family})
          studio.without_monitoring {studio.update_attributes(:_name => "Studio", :name_ru => "Студия", :open => false, :can_request_invite => false)}

          progress_log.debug "last processed user is #{user.id}" if i % 100 == 0
          print "\e[34m.\e[0m"
        end
        puts "\e[32mDONE\e[0m"
      end
    end

  end
end
