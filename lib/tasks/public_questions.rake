namespace :pq do
  desc "Assign users with questions"
  task :assign => :environment do
    Locale.set("en")

    questions_kits = YAML.load_file(File.join(Rails.root, "config", "public_questions.yml"))

    conditions = "pq.user_id IS NULL"
    joins = "LEFT JOIN public_questions AS pq ON pq.user_id = users.id"
    includes = :rare_user_settings
    User.paginated_each(:per_page => 1000, :conditions => conditions, :joins => joins, :readonly => false) do |user|
      downloadable_albums = user.contents.music_albums.select(&:downloadable?).count

      next if downloadable_albums == 0

      User.transaction do
        
        user.toggle_rare_setting!(:questions_enabled) unless user.questions_enabled?

        q = PublicQuestion.new(
          :user_id => user.id,
          :text => "Welcome to our Q&A Forum! Here you can ask us any question or start your own discussion.",
          :text_ru => "Здесь вы можете начать свою собственную дискуссию, или же задать нам вопрос. Мы постараемся Вам ответить."
        )
        q.without_monitoring do
          q.save
          q.publish!
        end

        questions_kit = questions_kits.select {|q| q[:enabled]}.rand

        user.rare_user_settings.update_attribute(:questions_kit_id, questions_kit[:id])

        SystemMessages::ShowTrigger.create(
          :user_id => user.id,
          :system_message_type => "SystemMessages::ForumEnabled"
        )

        questions_kit[:questions].each do |question|
          q = PublicQuestion.new(
            :user_id => user.id,
            :text_en => question[:en],
            :text_ru => question[:ru],
            :show_on_events => true
          )
          q.without_monitoring { q.save }
        end

        print "."
      end
    end
  end

  desc "Update questions assigned with users"
  task :reassign => :environment do
    Locale.set("en")

    questions_kits = YAML.load_file(File.join(Rails.root, "config", "public_questions.yml"))

    conditions = "pq.updated_by_id is NULL"
    joins = "JOIN public_questions AS pq ON pq.user_id = users.id"
    group = "pq.user_id"

    User.paginated_each(:per_page => 1000, :conditions => conditions, :joins => joins, :group => group) do |user|
      settings = user.rare_user_settings

      questions = PublicQuestion.with_user(user).unpublished.untouched
      questions_kit = questions_kits.detect {|q| q[:id] == settings[:questions_kit_id] && q[:enabled]}

      next if questions.size < 5 || questions_kit.blank?

      User.transaction do
        questions.map(&:destroy)

        questions_kit[:questions].each do |question|
          q = PublicQuestion.new(
            :user_id => user.id,
            :text => question[:en],
            :text_ru => question[:ru],
            :show_on_events => true
          )
          q.without_monitoring { q.save }
        end
      end
      print "."
    end

  end
end