class UploaderController < ApplicationController
  layout nil
  skip_before_filter :run_basic_auth, :only => [:load_id3_tags]
  skip_before_filter :verify_authenticity_token, :only => [:load_id3_tags]
  after_filter :dump_response

  def config
    #user = User.find_by_login(user_subdomain)
    if params[:id] == 'tracks'
      render :partial => 'tracks_config.xml.erb' #, :locals => {:albums => Album.album_menu(Track.new(:user => user))}
    else
      render :partial => 'images_config.xml.erb'
    end
  end

  def load_id3_tags
    files_data = ActiveSupport::JSON.decode(params[:files_data]).with_indifferent_access
    heads = files_data[:heads]
    tails = files_data[:tails]

    raise 'array expected for heads!' unless heads.is_a?(Array)
    raise 'array expected for tails!' unless tails.is_a?(Array)
    raise "heads count (#{heads.count}) doesn't match tails count (#{tails.count})!" if heads.count != tails.count
    files_data = (0..heads.size-1).to_a.map {|i| [heads[i], tails[i]]}
    files_data = files_data.map do |head, tail|
      #head is for ID3v2, tail is for ID3v1
      #we try tail first because
      # * tail is smaller, 755bytes max, and head may be cut too early (so invalid) if it has image
      # * ID3v1's genre is parsed better than ID3v2's: for ID3v2 it's returned like (8) sometimes
      log.debug "trying tail"
      tail_data = detect_tags(tail)
      if tail_data.size <= 4
        log.debug "tail's data is not full, let's try head too. tail is #{tail_data.inspect}"
        head_data = detect_tags(head)
        if tail_data.size >= head_data.size
          log.debug "head's data is less than tail. it's #{head_data.inspect}"
          tail_data.reverse_merge(head_data)
        else
          head_data.reverse_merge(tail_data)
        end
      else
        tail_data
      end

    end

    #get rid of ActiveSupport::Multibyte::Chars in files_data: it doesn't work well with json sometimes, resulting in ActiveSupport::JSON::CircularReferenceError 
    files_data = files_data.map {|file_data| file_data.to_a.map {|key, value| [key, value.to_s]}.to_hash}
    render :json => files_data
  end

  private
  include Id3TagsLoader

  def detect_tags(chunk)
    dir_path = "#{RAILS_ROOT}/tmp"

    filepath = "#{dir_path}/chunk_#{Time.now.to_f}.mp3"
    log.debug "base64 chunk size: #{chunk.size}"
    if chunk["\n"]
      newhead = chunk
    else
      newhead = "" 
      until chunk.blank?
        newhead += chunk[0..59].gsub(" ", "+")
        newhead += "\n"
        chunk = chunk[60..-1]
      end
    end
    #open("#{filepath}.base64", "wb") {|io| io.print(newhead) } #debug
    newhead = Base64.decode64(newhead)
    log.debug "decoded chunk size: #{newhead.size}"
    open(filepath, "wb") {|io| io.print newhead }

    result = decode_id3_tags(filepath)
    File.delete(filepath)
    result
  end
end
