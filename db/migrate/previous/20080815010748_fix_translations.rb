class FixTranslations < ActiveRecord::Migration

  # old version of rake trans:strings:import created records with no pluralization index. this fixes that. re-run after this to be sure.
  def self.up
    
    russian_id = Language.find_by_english_name('Russian').id
    french_id = Language.find_by_english_name('French').id
    
    wrongs = Translation.find(:all, :conditions => {:pluralization_index => nil})
    wrongs.each_with_index do |w, index|
      puts "  - Fixing #{index+1} out of #{wrongs.size}" if (index+1) % 20 == 0
      
      [russian_id, french_id].each do |lang_id|
        all = Translation.find(:all, :conditions => {:tr_key => w, :language_id => lang_id})
        if all.size == 1 # If just one, give it a pluralization index
          all.update_attribute(:pluralization_index, 1) 
        else # If multiple, keep one with text, or just the first, and give it pluralization index. remove the rest.
          to_keep = all.detect{|x| !x.text.blank?} || all.first
          all.each do |x|
            x.destroy unless x == to_keep
          end
          to_keep.update_attribute(:pluralization_index, 1) if to_keep
        end
      end
    end
    
    # Translation.delete_all 'pluralization_index is null'
  end

  def self.down
  end
end
