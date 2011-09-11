class NewContent < ActiveRecord::Base
  belongs_to :content
  
  def self.min_content_id
    min_id = Rails.cache.fetch(:new_content_min_id)
    unless min_id
      min_id ||= NewContent.minimum(:content_id) || 0
      Rails.cache.write(:new_content_min_id, min_id)
    end
    min_id
  end

  def self.in_window?(content_id)
    min_content_id <= content_id
  end

  def self.recent_content(options = {})
    options = {:per_page => options} unless options.is_a?(Hash)
    options.reverse_merge!(:page => 1, :per_page => 4)
    finder_options = {:conditions => 'true',
                      :joins => "inner join new_contents nc on nc.content_id = contents.id"}
    finder_options.merge!(options.select {|key, value| [:page, :per_page].include?(key)}.to_hash)
    if options[:only_languages] == 'en'
      finder_options[:joins]      << " inner join users u on contents.user_id = u.id"
      finder_options[:conditions] << " AND contents.title != '' and u.display_name != ''"
    end
    if options[:only_albums]
      #TODO: make Music Contests shown in New module
      types = (Content::ALBUM_TYPE_NAMES - ['MusicContest']).map{|t| "'#{t}'"}.join(", ")
      finder_options[:conditions] << " AND contents.type IN (#{types})"
    end
    finder_options.merge!(:order => 'content_id desc')

    if finder_options[:conditions] == 'true'
      finder_options.delete(:conditions)
      finder_options.delete(:joins)
      pager = NewContent.paginate(finder_options)
      contents = Content.find(:all, :conditions => ['id in (?)', pager.map(&:content_id)], :order => 'id desc')
    else
      pager = Content.paginate(finder_options)
      contents = pager
    end
    [contents, pager]
  end

  def self.valid_content?(content)
    !content.user.private? && content.public? && content.active? &&
            Content.public_stream_classes.include?(content.class.name) &&
            !Content.categories_rejected_from_public_stream.include?(content.cat_id) &&
            content.original_content_id == content.id && (!content.albums.empty? || content.is_in_gallery) 
  end

  def self.fill_with_content(n)
    NewContent.transaction do
      NewContent.delete_all
      
      reject_categories = Content.categories_rejected_from_public_stream.join(',')
      allow_classes = Content.public_stream_classes.map {|c| "'#{c}'"}.join(',')
      #use index(index_contents_on_type_and_created_at)
      Content.find_by_sql(%Q{
        SELECT contents.* FROM contents
        INNER JOIN users ON users.id = contents.user_id
        WHERE contents.cat_id not in (#{reject_categories})
        and contents.type in (#{allow_classes})
        and contents.relationshiptype_id = #{Relationshiptype.everyone} AND contents.state='active' AND !users.private
        and ((select count(*) from album_items ai where ai.content_id = contents.id) > 0 OR contents.is_in_gallery)    
        ORDER BY id DESC LIMIT 0, #{n}}).each do |c|

        NewContent.create!(:content_id => c.id)
      end
    end
    reset_min_id
  end

  def self.truncate(n, opts = {})
    stale = NewContent.find(:first, :order => 'content_id desc', :limit => 1, :offset => n)
    if stale
      NewContent.connection.execute("DELETE FROM new_contents WHERE content_id <= #{stale.content_id}" +
              (opts[:batch_size] ? " LIMIT #{opts[:batch_size]}" : ''))
      reset_min_id
    end
    stale
  end

  private

  def self.reset_min_id
    Rails.cache.delete(:new_content_min_id)
  end

end
