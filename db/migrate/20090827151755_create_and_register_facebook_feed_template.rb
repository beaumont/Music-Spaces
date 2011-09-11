require 'lib/facebook/publisher'

class CreateAndRegisterFacebookFeedTemplate < ActiveRecord::Migration
  def self.up
    create_table :facebook_templates, :force => true do |t|
      t.string :bundle_id,:template_name
      t.timestamps
    end
    Facebook::Publisher.register_profile_feed
  end

  def self.down
    drop_table :facebook_templates
  end
end
