module TranslationTasksMixin
  BULK_FILENAME_ID = 'bulk'
  INCREMENT_FILENAME_ID = 'increment'

  def translation_base
    File.expand_path('db/translations', RAILS_ROOT)
  end

  def model
    ViewTranslation
  end

  def clean_old_translation_files(bulk_file)
    files = files_older_than(number_from_name(bulk_file))
    files.each do |f|
      @report << "Removing old file #{f}\n"
      @report << `svn rm #{File.join(translation_base, f)}` + "\n"
    end
    unless files.blank?
      @report << "Commiting changes to db/translation directory\n"
      @report << `svn commit #{File.join('db', 'translations')} -m "Autoremoving old translation files (rake task)"` + "\n"      
    end
  end

  # Return the language id for the given language
  def language_id(language_name)
    return Language.find_by_english_name(language_name).id
  end

  # Grab table and dump it to file
  def dump_to_file(options = {})
    options.reverse_merge!(:bulk => false)
    bulk_mode = options[:bulk]
    version = Time.now.utc.stamp
    file_name = "#{version}_#{bulk_mode ? BULK_FILENAME_ID : INCREMENT_FILENAME_ID}.yml"
    records = []

    # require 'ruby-debug'
    # debugger

    conditions = 'text <> "dnr"' # Don't dump out records marked Do Not Resuscitate
    conditions << " AND to_dump" unless bulk_mode
    records = model.find(:all, :conditions => conditions).map {|r| r.attributes}
    records.each do |r|
      %w(id type facet item_id namespace obsolete table_name from_bundle to_dump).each {|field| r.delete(field)}
    end

    if records.empty?
      @report << "No records found, no sense in creating a file\n"
      return nil, 0
    end

    write_file(File.join(translation_base, file_name), records.ya2yaml)
    if bulk_mode
      model.update_all(['to_dump = ?', false])
      #no sence in loading our own bundle later.
      #but this is only for bulks because partials are downloaded from site and might not make it to SVN
      TranslationBundle.create!(:version => version, :bulk => true)
    end

    record_n = records.size 
    puts "\tDumped #{record_n} records into file #{file_name}"

    if options[:svn]
      a = `svn add #{File.join(translation_base, file_name)}`
      puts a =~ /^A/ ? "Added #{file_name} to svn" : "Error adding #{file_name} to svn:\n\t#{a}"
    end

    return file_name, record_n
  end

  # Handle the actual writing
  def write_file(path, content)
    f = File.new(path, "w+")
    f.puts content
    f.close
  end

  def has_html_tags?(string)
    string =~ /<\w+>/
  end

  def bulk_file?(file_name)
    !!file_name[BULK_FILENAME_ID]
  end

  def del_existing_record?(existing, new)
    log.debug "existing.to_dump: %s" % existing.to_dump
    return true if existing.to_dump #to_dump records are always throwaway to avoid mess
    log.debug "existing.created_at < new.created_at: %s" % (existing.created_at < new.created_at)
    return true if existing.created_at < new.created_at
    log.debug "existing.updated_at < new.updated_at: %s" % (existing.updated_at < new.updated_at)
    return true if existing.updated_at < new.updated_at
    #no matter if text or origin is different - we know it's not newer, so cancel
    return false
  end
  
  def load_file(file_name, options)
    version = number_from_name(file_name)
    log.debug "version of #{file_name} is #{version}"
    if tb = TranslationBundle.find_by_version(version)
      unless options[:force]
        return 0
      else
        tb.destroy
      end
    end

    bulk_mode = bulk_file?(file_name)
    
    # Clear the table, prep for new data
    model.connection.execute('truncate %s' % model.table_name) if bulk_mode

    records = read_file( File.join(translation_base, file_name) )
    counter = 0
    @report << "Found #{records.size} records in #{file_name} \n"
    @report << "Processing: "
    hundredth = records.size / 100
    hundredth = 1 if hundredth < 1

    #for updated_at not to become now - it's important now
    ActiveRecord::Base.record_timestamps = false
    records.each_with_index do |r, index|
      attributes = r.is_a?(Hash) ? r : r.attributes
      tran = model.new(attributes)
      unless bulk_mode
        existing = model.find(:first, :conditions => {:language_id => tran.language_id, :tr_key => tran.tr_key,
                                                      :pluralization_index => tran.pluralization_index})
        log.debug "existing: %s" % existing.inspect
        if existing
          if del_existing_record?(existing, tran)
            existing.destroy
            log.debug "destroyed existing translation: %s" % existing.id
          else
            log.debug "skipped translation for %s (language %s) from %s: already translated in DB" % [tran.tr_key,
                 tran.language_id, file_name]
            next
          end
        end        
      end

      #this is to keep updated_at value from dump
      model.record_timestamps = false
      tran.from_bundle = file_name
      tran.save!
      model.record_timestamps = true
      counter += 1
      if (index % (hundredth*10) == 0)
        $stdout.print " #{index} "; $stdout.flush
      elsif (index % hundredth == 0)
        $stdout.print "."; $stdout.flush
      end
    end
    ActiveRecord::Base.record_timestamps = true
    TranslationBundle.create! :version => version, :bulk => bulk_mode

    @report << "\nLoaded #{counter} records from file #{file_name}\n\n"

    clean_old_translation_files(file_name) if bulk_mode

    return counter
  end
  
  # Grab the latest bulk file and increments after it and load them into table.
  #If :force => true each file is loaded even if it was loaded before.  
  def load_files(options = {})
    files = files_newer_than(0).sort_by{|a| number_from_name(a).to_i}
    return if files.empty?
    log.debug "files: #{files.inspect}"
    
    last_bulk = files.select {|fn| bulk_file?(fn)}.last
    if last_bulk
      to_load = files[files.index(last_bulk)..-1]
    else
      to_load = files
    end

    counter = 0
    TranslationBundle.delete_all if options[:force]
    to_load.each {|fn| counter += load_file(fn, options)}
    @report << "no files loaded - they are already in the database\n" if counter == 0
    counter
  end

  # Handle the actual reading
  def read_file(path)
    YAML::load( File.open(path) )
  end

  # All the files starting with a number in the TRANSLATION_BASE directory
  def file_dumps
    Dir.new(translation_base).entries.select{|x| x['.yml']}
  end

  # Figure out the most recent revision
  def most_recent_file_number
    file_dumps.collect {|x| number_from_name(x)}.compact.sort.last || 0
  end

  # If we add a new file, what number should it be?
  def next_file_number
    most_recent_file_number + 1
  end

  # If database is at version n, run these files to bring it up to date
  def files_newer_than(n = 0)
    file_dumps.select {|x| number_from_name(x) > n}
  end

  def files_older_than(n = 0)
    file_dumps.select {|x| number_from_name(x) < n}
  end

  # Given a filename, return its numeric prefix or nil
  def number_from_name(name)
    return nil unless name
    match = name.scan(/^(\d+)/).first
    match ? match.first.to_i : nil
  end

  require 'find'
  require "eregex"

  # Number of plural forms per language
  LANG_PLURALS = {
    'English'  => 2,
    'French'   => 2,
    'Russian'  => 3
  }

  # Locale.set_translation(key, [singular, plural_1, ... plural_n], zero)

  # Double and single quote versions of a regexp to match strings requiring translation

  # string can include escaped quotes, and must end with .t versions
  def self.t_pattern(quote)
    Regexp.new(/(#{quote}([^#{quote}\\]*(?:\\.[^#{quote}\\]*)*)#{quote}(?:\.(?:t|tdown|tup)\b))/)
  end
  SQ_T = t_pattern("'")
  DQ_T = t_pattern('"')

  # Captures an extra 10 characters to use later to knock out bad matches (e.g. <tag attr="value" />)
  def self.sword_pattern(quote)
    Regexp.new(/(#{quote}((?!\.t)[^#{quote}\\]*(?:\\.[^#{quote}\\]*)*)#{quote}(?:\s+\/[^>]).{0,10})/)
  end
  SQ_LAX = sword_pattern("'")
  DQ_LAX = sword_pattern('"')

    # Don't search for translations in files that match these paths
    DIRS_TO_EXCLUDE = ['plugins/newrelic', 'lib/kroogi_format.rb', 'lib/recipes', 'lib/tasks', 'plugins/globalize', 'plugin_hacks_test', 'test_helper']

    def grab_translations(dir)
      report = @report
      report << "\nParsing files from #{dir}\n"

      strings = {}
      files = 0
      Find.find(dir) do |path|
        next if DIRS_TO_EXCLUDE.any?{|d| path[d]}

        if FileTest.directory?(path)
          Find.prune if File.basename(path) == '.svn'     # Don't look into svn directories
          Find.prune if File.basename(path) == 'rescues'  # Don't look here either
        else
          next if File.basename(path).match(/^\./)    # No dotfiles, please
          get_strings_from_file(path, strings)
          files += 1
        end
      end
      strings.keys.sort!.uniq!

      report << "   ... found #{strings.size} unique strings in #{files} files\n\n\n"
      report << strings if ENV['SHOW']
      strings
    end

    def scan_strings
      strings = {}
      strings.merge! grab_translations(File.join(RAILS_ROOT, 'app'))
      strings.merge! grab_translations(File.join(RAILS_ROOT, 'vendor', 'plugins', 'plugin_hacks'))
      strings.merge! grab_translations(File.join(RAILS_ROOT, 'lib'))
      strings
    end

  def file_matches(path, pattern)
    matches = []
    File.open(path, 'r') do |f|
      f.each_line do |line|
        line.scan(pattern).each {|match| matches << match}
      end
    end
    matches
  end

  # Return all translatable strings in this file
  def get_strings_from_file(path, result_hash = {})
    here = path.gsub(RAILS_ROOT.chomp,"")
    # Get translations guesses (using the 'thing' / [] style)
    potentials = []
    potentials += file_matches(path, SQ_LAX)
    potentials += file_matches(path, DQ_LAX)

    # Get known translation strings (.t)
    potentials += file_matches(path, DQ_T)
    potentials += file_matches(path, SQ_T)

    # Filter out known bad (some things are miserble to try in the regexp)
    probables = []
    potentials.each do |s|
      full_str = s[0]
      matched_str = s[1]
      next if matched_str.match(/#\{.*\}/) # e.g. "#{myvar}".t
      #next if full_str.match(/(<%)|(%>)/) # e.g. any inline code
      next unless matched_str.match(/\w/) # ensure something worth translating

      probables << matched_str # Just the relevant matched portion
    end

    # Remove escaped quotes
    probables.each do |str|
      str.gsub!("\\'", "'")
      str.gsub!('\\"', '"')
      result_hash[str] ||= []
      result_hash[str] << here
    end

    return result_hash
  end

  def strings_by_case(strings)
    strings_by_case = {}

    strings.each do |str, origins|
      strings_by_case[str.downcase] ||= []
      strings_by_case[str.downcase] << [str, origins]
    end
    strings_by_case
  end

  def import_strings(options = {})
    report = @report
    strings = scan_strings
    report << "\nLoading fresh translations before importing...\n"

    files = files_newer_than(0).sort_by{|a| number_from_name(a).to_i}
    last_bulk = files.select {|fn| bulk_file?(fn)}.last

    force = options[:force]
    if !force && last_bulk && model.find_by_to_dump(true) && !TranslationBundle.find_by_version(number_from_name(last_bulk))
      report << "There's a bulk translations file, #{last_bulk}, not loaded yet. It needs to be loaded before the import, " +
              "but then you would loose fresh undumped translations you have. The import was stopped.\n"
      if defined?(action_name) && RAILS_ENV != 'development'
        report << "Please dump your fresh translations (if any) and commit them, re-deploy this instance (or run load_tran.sh)."
      else
        report << "Please dump your fresh translations (if any) and run rake db:trans:load."        
      end
      report << " Then you'll be able to scan the code."
      report << "\n"
      return
    end

    load_files

    dry_run = !!ENV['DRY_RUN']
    update_origins = (ENV['ORIGINS'] != 'false')
    if dry_run
      report << "Dry run of string importation from local code\n"
    else
      report << "\nImporting #{strings.size} strings\n"
    end
    english_id = Language.find_by_english_name('English').id
    russian_id = Language.find_by_english_name('Russian').id
    french_id = Language.find_by_english_name('French').id
    language_ids = [english_id, russian_id, french_id]
    if dry_run
      report << "\n\n[ STRINGS TO BE ADDED ]\n"
    else
      report << "\t- Adding new strings (or unobsoleting old) to the database (to be translated)\n"
    end
    newly_added = 0
    updated = 0

    strings_by_case = self.strings_by_case(strings)

    ids_with_sources = Set.new
    strings.each do |str, origins|
      #next unless str == 'Post Announcement'
      next unless strings_by_case[str.downcase].select {|s, o| s != str}.empty?

      language_ids.each do |lang_id|
        # If the string has a %d in it, create an entry for each pluralization index this language has
        pluralization_indexes = if (str.match(/%d/) || str['{{count}}'])
          LANG_PLURALS[Language.find(lang_id).english_name]
        else 1
        end

        1.upto(pluralization_indexes) do |p_idx|

          unless view_trans = ViewTranslation.find(:first, :conditions => {:tr_key => str, :language_id => lang_id, :pluralization_index => p_idx})
            newly_added += 1
            if dry_run
              report << "\t+ #{str} (origin: #{origins[0]})\n"
            else
              begin
                view_trans = ViewTranslation.create(:tr_key => str, :language_id => lang_id, :pluralization_index => p_idx, :tr_origin => origins[0])
                ids_with_sources << view_trans.id
              rescue => e
                log.error("failed to load string '%s': %s" % [str, e])
              end
            end
          else
            ids_with_sources << view_trans.id
            if update_origins
              if dry_run
                report << "#{view_trans.id}\t= #{str} (origin: #{origins[0]})\n"
              else
                origin = origins.include?(view_trans.tr_origin) ? view_trans.tr_origin : origins[0]
                view_trans.update_attributes(
                    :tr_key => str, :language_id => lang_id,
                    :pluralization_index => p_idx,
                    :tr_origin => origin, :obsolete => false)
              end
            end

          end

        end
      end
    end

    if update_origins && !dry_run
      ids = ViewTranslation.connection.select_rows('select id from globalize_translations where type = \'Globalize::ViewTranslation\' and tr_origin is not null').
              flatten.map {|id| id.to_i}
      no_origin_ids = Set.new(ids) - ids_with_sources
      ViewTranslation.update_all(['to_dump = 1, tr_origin = null, updated_at = ?', Time.now.utc], ['id in (?)', no_origin_ids])
      monthes_to_keep_obsolete = 4
      report << "Deleted %s obsolete records older than %s monthes\n" % [GlobalizeTranslation.delete_all('tr_origin is null and updated_at < DATE_SUB(NOW(), INTERVAL %s MONTH)' % monthes_to_keep_obsolete), monthes_to_keep_obsolete]
    end

    to_trans = ViewTranslation.count(:conditions => ["(text is NULL or text = '') and language_id=? and obsolete=?", russian_id, false])
    if dry_run
      report << "\n\nThere are #{to_trans + newly_added} untranslated strings across all languages\n"
    else
      report << "\t\t[Added #{newly_added} (not necessarily unique) strings]\n"
      report << "\t\t[Updated #{updated} strings]\n"

      report << "\n\n\n\n"
      report << "[ UNTRANSLATED STRINGS IN THE DB ]\n"
      language_ids.each do |lang_id|
        count = ViewTranslation.count(:conditions => ["(text is NULL or text = '') and language_id=? and obsolete=?", lang_id, false])
        report << "\t- #{Language.find(lang_id).english_name}: #{count}\n"
      end
    end

    build_mixed_cases_report(strings_by_case)
    
    report << "\n\n\n"
  end

  def build_mixed_cases_report(strings_by_case)
    mixed_cased = strings_by_case.map {|lower, pairs| pairs}.
      select {|pairs| pairs.map {|str, orig| str}.uniq.size > 1}

    mixed_cased.each do |pairs|
      @report << "\n\tError! Translation string has mixed case problem.\n"
      @report << (pairs.map {|str, origins| "\n\t  in \n\t  %s it's\n\t  '%s'" % [origins.inspect, str]}.join(", and") + "\n")
    end
    @report << "\n\n\t%d mixed case errors found.\n" % mixed_cased.size unless mixed_cased.blank? 
  end
end