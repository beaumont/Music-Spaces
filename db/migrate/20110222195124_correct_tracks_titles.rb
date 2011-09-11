class CorrectTracksTitles < ActiveRecord::Migration
  def self.log_msg(msg, log)
    puts msg
    log.debug msg
  end

  def self.up
    conditions = {:conditions => ['id > 0']}
    count = Track.count(conditions)
    page_size = 100
    progress_log = Logger.new('log/compress_feed_entries.log')
    updated = 0
    i = 0
    Track.paginated_each(conditions.merge(:order => 'id desc', :per_page => page_size)) do |content|
      log_msg("Processed #{i} contents out of #{count}. Updated #{updated}.", progress_log) if i % page_size == 0
      i += 1
      attribs = {}
      ["_title", "title_ru"].each do |attrib|
        attribs[attrib] = content.send(attrib).chars[1..-1] if content.send(attrib).to_json.starts_with?("\"\\ufeff")        
      end
      unless attribs.empty?
        content.update_attributes!(attribs)
        updated += 1
      end
    end
    log_msg "Processed #{count} contents, updated #{updated}.", progress_log
  end

  def self.down
  end
end
