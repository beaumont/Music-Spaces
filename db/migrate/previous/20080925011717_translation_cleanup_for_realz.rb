class TranslationCleanupForRealz < ActiveRecord::Migration

  # Reference: "id","type","tr_key","table_name","item_id","facet","language_id","text","pluralization_index"
  #  (cvs layout of translation_data)
  def self.up
    # For later, but stop now if there's going to be a problem
    puts "Preloading various data necessary to clean translations..."
    fpath = File.join(RAILS_ROOT, 'vendor', 'plugins', 'globalize', 'data', 'translation_data.csv')
    builtins = CSV::read(fpath)
    raise "WTF - can't find globalize data file" unless File.file?(fpath) || builtins.blank?
    builtins = builtins[1, builtins.size - 1]  # drop the first row (headers)



    puts "\nRemove anything not English, Russian, or French"
    n = ViewTranslation.delete_all "language_id not in ('1819', '1930', '5556')"
    puts "  - Removed #{n} entries"

    puts "\nFixing all old translations where the built_in was set to 1 improperly"
    n = ViewTranslation.update_all 'built_in = NULL'
    puts "  - Updated #{n} entries"
    
    puts "\nLoaded in all real builtins, updating the built_in value of any improperly set to null above"
    %w(1819 1930 5556).each do |lang|
      built_for_lang = builtins.select{|x| x[6] == lang}
      language = Language.find_by_id(lang) ? Language.find_by_id(lang).english_name : lang
      if built_for_lang.empty?
        puts "  - No builtins for #{language}"
        next
      end

      updates = 0
      added = 0
      built_for_lang.each do |b|
        if existing = ViewTranslation.find_by_language_id_and_tr_key_and_pluralization_index(b[6], b[2], b[8])
          existing.update_attribute(:built_in, true)
          updates += 1
        else
          added += 0
        end
      end
      puts "  - Updated builtins for #{language}: #{updates} updated, #{added} added"
    end


    puts "\nMerging existing entries with multiple entries per tr_key/language"
    %w(1819 1930 5556).each do |lang|
      [0,1,2,3].each do |pidx|
        # Are there any entries with this language/pluralization_index? Skip if not
        all_trs = ViewTranslation.find_by_sql("select tr_key, pluralization_index, COUNT(id) as n_matches from globalize_translations where language_id=#{lang} and pluralization_index=#{pidx} group by tr_key")
        next if all_trs.empty?

        puts "  - Cleaning #{all_trs.size} unique tr_keys with language #{lang} and pluralization_index #{pidx}"

        # For each tr_key/lang/pluralization index, see if there are multiple entries.
        all_trs.each do |tr|
          # Keep looking if not (no duplicates == nothing to clean)
          next if tr.n_matches.to_i < 2

          # If there are grab, them all and select which to keep:
          dups = ViewTranslation.find(:all, :conditions => ['language_id=? and pluralization_index=? and tr_key=?', lang, pidx, tr.tr_key])

          # Select entry to keep: look for entry with text. If multiple with text, grab the most recent. If only one with text, grab it.
          all_with_text = dups.select{|x| !x.text.blank?}
          to_keep = all_with_text.sort_by(&:updated_at).last

          # If none with text, grab the most recent entry
          to_keep ||= dups.sort_by(&:updated_at).last

          # Announce decision to user
          puts "      - Chose to keep #{to_keep.id} (#{to_keep.text.blank? ? 'no text' : 'has text'}) from #{dups.size} duplicates (#{all_with_text.size} w/ text)"

          # Remove the others
          ViewTranslation.delete_all ['language_id=? and pluralization_index=? and tr_key=? and id<>?', lang, pidx, tr.tr_key, to_keep.id]
        end

      end # END pluralization_index loop
    end # END language_id loop


  end

  def self.down
  end
end
