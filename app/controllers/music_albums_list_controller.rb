class MusicAlbumsListController < ApplicationController
  def index
    order_by = 'ORDER BY id desc'
    group = "GROUP BY users.id"
    select = <<-EOSQL
        SELECT users.*, count(c.id) as ma_count FROM users
        INNER JOIN contents c ON c.user_id = users.id AND c.title is not null and c.title != ''
          AND c.type = 'MusicAlbum' AND c.state = 'active' AND c.relationshiptype_id = -2
        WHERE users.private = 0
        #{group}
        #{order_by}
    EOSQL

    users = User.find_by_sql(select)
    render :xml => {'page' => 1, 'total_pages' => 3, 'projects' => users.map {|u| {
            :id => u.id,
            :formation_date => (u.birthdate || Date.today),
            :name => u.display_name,
            :page_url => user_url(u.login),
            :about => u.profile.about_us,
            :zvuki_ru_url => "http://www.zvuki.ru/A/P/#{u.id}",
            :contribute_url => user_url_for(u, :contribute => true, :from => 'zvukiru', :return_to => 'zvuki_ru_url'),
            :albums => u.music_albums.map {|ma| {
                    :id => ma.id,
                    :contribute_url => content_url(ma, :contribute => true, :from => 'zvukiru', :return_to => 'zvuki_ru_url'),
                    :download_url => content_url(ma, :download => true, :from => 'zvukiru', :return_to => 'zvuki_ru_url'),
                    :title => ma.title,
                    :year => ma.year,
                    :cover_art => ma.cover_art_url,
                    :player_code => %Q{
                      <object id="kroogi_player_#{ma.id}" width="500" height="331"> <param name="wmode" value="transparent" /> <param name="movie" value="http://kroogi.com/flash/audioplayer.swf" /> <param name="flashvars" value="playlist_url=http%3A%2F%2F#{CGI::escape(APP_CONFIG.hostname)}%2Fplayer%2Fembedded_play_list.xml%3Falbum_id%3D#{ma.id}%26amp%3Blocale%3Dru%26width%3D500&player_mode=embedded" /> <param name="allowScriptAccess" value="always" /> <embed name="kroogi_player_#{ma.id}" src="http://kroogi.com/flash/audioplayer.swf" type="application/x-shockwave-flash" width="500" height="331" flashvars="playlist_url=http%3A%2F%2F#{CGI::escape(APP_CONFIG.hostname)}%2Fplayer%2Fembedded_play_list.xml%3Falbum_id%3D#{ma.id}%26amp%3Blocale%3Dru%26width%3D500&player_mode=embedded" allowScriptAccess="always" wmode="transparent"> </embed> </object>
                    },
            }},
    }}}
  end
end
