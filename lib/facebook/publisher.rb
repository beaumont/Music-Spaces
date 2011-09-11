require 'vendor/plugins/facebooker/lib/facebooker/rails/publisher'

class Facebook::Publisher < Facebooker::Rails::Publisher
  
  def profile_feed(user,content)
    album_url = url_for(:controller => "content",
                        :action => "show",
                        :host => Facebooker.canvas_server_base + Facebooker.facebook_path_prefix,
                        :id => content.id,
                        :fb_referrer_id => (user.facebook_id if user),
                        :fb_referral_type => ("profile" if user),
                        :escape => false
                        )
    image =  content.respond_to?(:cover_art) && content.cover_art ? content.cover_art.thumb(:thumb).public_filename : image_path('AlbumNoPictureLarge.png')
    image_url = user ?  album_url : url_for(:controller => "content", 
                                            :action => "show",
                                            :host => Facebooker.canvas_server_base + Facebooker.facebook_path_prefix,
                                            :id=> content.id)

    send_as :publish_stream
    from  user
    target user
    attachment :attachment=>{
                    :name=>"#{content.title} from #{content.user.display_name}",
                    :href=>"#{album_url}",
                    :caption=> "Check out #{content.title} from #{content.user.display_name}",
                    :media => [{
                      :type => 'image',
                      :src  => "#{image}",
                      :href => "#{image_url}"
                    }]
               }
  end

end
