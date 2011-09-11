class FixDb < ActiveRecord::Migration
  def self.up
    change_column :faqs, :answer_ru, :text
    Track.delete_all 'filename IS NULL'
    
    say "PATIENCE: going to run all existing models through xss_terminate"
    model_files = File.join(RAILS_ROOT, 'app', 'models')
    ignore = /notifier|observer|guest|status|configu|stat|comment/
    subclass = /blog|board|album|image|pvtmessage|textentry|track|project|kroogi_setting/
    models = Dir.new(model_files).entries.grep(/\.rb/).select{|x| !x.match(ignore) && !x.match(subclass)}
    models = models.collect {|n| n.gsub('.rb', '').humanize.split.map(&:capitalize).join}
    models.each do |m|
      say "xss_terminate-ing #{m}"
      `rake xss_terminate MODELS=#{m}`
    end
    say "All Done"
  end

  def self.down
  end
end
