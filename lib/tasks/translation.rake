require 'translation_tasks_mixin'
namespace :trans do

  namespace :cache do

    # TODO -- ping all mongrels in parallel (just use curl?)
    # TODO -- do maintenance via cap task... or otherwise verify it works
    # TODO -- ensure can still access mongrel via localhost urls when system/maintenance.html file exists
    desc 'Reloads the translation cache for all current mongrels'
    task :reload => [:environment] do
      # We have to call I18n.backend.send :init_translations for all EXISTING application instances...
      require 'open-uri'
      require 'digest/sha1'


      # Get existing mongrel instances
      ps_list = `ps ax | grep mongrel`
      matches = ps_list.scan(/mongrel\.(\d+?)\.pid/)
      mongrels = matches.inject([]) {|all, m| all << m.first.to_i}
      mongrels << [ENV['PORT'] || 3000] if mongrels.blank? && RAILS_ENV == 'development'
      if mongrels.blank?
        puts "NO MONGRELS FOUND" 
      else
        puts "Found #{mongrels.size} mongrels. Loading the translation wait screen to prevent requests while we update translations..."
        put_translation_wait_screen

        # Ping each running mongrel server
        puts "Hitting reload url for all existings mongrels"
        token = Digest::SHA1.hexdigest("XZAVL3hzexCRTUwSRZ--Date--#{Time.now.utc.to_date.to_s}")
        mongrels.each do |port|
          puts "  * #{port}..."
          puts "    -> " + open("http://localhost:#{port}/api/reload_translation_cache/#{token}", :http_basic_authentication => mongrel_auth_info).read
        end
        remove_translation_wait_screen
      end

    end

    def mongrel_auth_info
      return nil if RAILS_ENV == 'production' || RAILS_ENV == 'development'
      raise "Rake task requires a valid user/password for HTTP BASIC AUTH in mongrel_auth_info w/ rails_env #{RAILS_ENV}" unless User.lnjoe && User.lnjoe.authenticated?('password')
      ['joe', 'password']
    end

    # Copied from custom.rb's put_maintenance_template capistrano task
    TRANSLATION_SCREEN_LOCATION = RAILS_ENV=='development' ? './tmp/maintenance.html' : "../../shared/system/maintenance.html"
    def put_translation_wait_screen  
      puts "Creating translation wait screen at #{TRANSLATION_SCREEN_LOCATION}"
      disable_template = File.join('.', 'app', 'views', 'errors', 'generic.rhtml')
      template = File.read(disable_template)
      title = 'Updating Translations'
      msg = "We'll be back soon"
      maintenance = ERB.new(template).result(binding)

      nfile = File.new(TRANSLATION_SCREEN_LOCATION, 'w')
      nfile.puts maintenance
      nfile.close
    end

    def remove_translation_wait_screen
      if File.exists?(TRANSLATION_SCREEN_LOCATION)
        puts "Removing translation wait screen"
        File.delete(TRANSLATION_SCREEN_LOCATION)
      else
        puts "Translation wait screen not found at #{TRANSLATION_SCREEN_LOCATION}: nothing to remove"
      end
    end
  end

  namespace :strings do
    include TranslationTasksMixin

    desc 'Update database to contain strings from the local code. Honors DRY_RUN=1 option.'
    task :import => [:environment] do
      @report = $stdout
      import_strings(:force => !!ENV['FORCE'])
    end

    desc 'Extract strings from a file or files specified (used for testing)'
    task :extract do
      files = ARGV[1].split('|')

      files.each do |file|
        puts "File: #{file}\n"
        here = RAILS_ROOT
        puts get_strings_from_file(file.starts_with?('/') ? file : "#{here}/#{file}").collect{|x| "  - #{x}"}
        puts "\n\n"
      end
    end

  end

end

  namespace :db do
    namespace :trans do

      include TranslationTasksMixin
      
      desc "Dump the translations tables. SKIP_SVN=1 to skip adding to svn."
      task :dump => :environment do
        puts "Dumping translations out to file..."
        @report = $stdout
        file_name, record_n = dump_to_file(:bulk => !!ENV['BULK'], :svn => !ENV['SKIP_SVN'])
      end

      desc "Load the translations"
      task :load => :environment do
        begin
          puts "\nLoading translations..."
          @report = $stdout
          count = load_files(:force => !!ENV['FORCE'])
        rescue => e
          puts "\n\tError loading translations: #{e.inspect}\n\n"
        end
        if count > 0
          begin
            Rake::Task['trans:cache:reload'].execute unless ENV['RELOAD'] == 'false'
          rescue
            puts "Couldn't apply translations to running app: #{$!}\n\n"
          end
        end
      end
    end
  end



  desc 'Clear duplicate pluralization indexes, etc from db'
  task "db:trans:clean" => :environment do
    %w(russian french).each do |language_name|
      language_id = Language.find_by_english_name(language_name)
      puts "Cleaning #{language_name.capitalize} translations"
      tr_keys = ViewTranslation.find(:all, :conditions => {:language_id => language_id}, :group => 'tr_key').map(&:tr_key)
      puts "\tLoaded #{tr_keys.size} unique tr_keys. Now cycling through each..."

      # OK, for every translatable string for this language, we want to ensure there's only one translation per pluralization_index
      tr_keys.each do |key|
        all_translation_for_key = ViewTranslation.find(:all, :conditions => {:language_id => language_id, :tr_key => key})
        next if all_translation_for_key.size < 2
        puts %Q{\tCleaning "#{key[0..60]}"} unless key['%d']

        with_index = auto_categorize(all_translation_for_key, :pluralization_index)

        with_index.keys.each do |index|
          if index > 1 && !key['%d']
            # If the key doesn't have a %d in it, it should only have pluralization index = 1
            puts "\t\t- Removing #{with_index[index].size} entr#{with_index[index].size == 1 ? 'y' : 'ies'} with invalid pluralization_index #{index}"
            ViewTranslation.delete_all ['id in (?)', with_index[index].map(&:id)]
          elsif with_index[index].size > 1
            # For each index, only keep one translation: the most recent addition with a translation
            all_sorted = with_index[index].sort_by(&:updated_at)
            to_keep = all_sorted.select{|x| !x.text.blank?}.last || all_sorted.last
            puts "\t\t- Removing #{with_index[index].size - 1} duplicate#{with_index[index].size == 2 ? '' : 's'}. Keeping id #{to_keep.id} (#{to_keep.text.blank? ? 'no' : 'has'} text)"
            puts "\t\t  [DEBUG] DELETING: #{(with_index[index].map(&:id) - [to_keep.id]).sort.join(',')}"
            ViewTranslation.delete_all ['id in (?)', (with_index[index].map(&:id) - [to_keep.id])]
          end

        end
      end
    end
  end

  def auto_categorize(object_array, key)
    hash = {}
    object_array.each do |item|
      hash[item.send(key)] ||= []
      hash[item.send(key)] << item
    end
    return hash
  end