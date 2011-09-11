#  create_table "smscoin_versions", :force => true do |t|
#    t.column "json",               :text,     :default => "", :null => false
#    t.column "created_at",         :datetime,                 :null => false
#    t.column "last_checked_at",    :datetime,                 :null => false
#    t.column "cached_data_digest", :string,                   :null => false
#    t.column "finished",           :boolean,  :default => false, :null => false
#  end
#
require 'digest/md5'
module Smscoin
  class Version < ActiveRecord::Base
    JSON_RU_URL = "http://service.smscoin.com/json/bank/#{APP_CONFIG.smscoin[:purse_id]}/"
    JSON_ENG_URL = "http://service.smscoin.com/language/english/json/bank/#{APP_CONFIG.smscoin[:purse_id]}/"
    set_table_name 'smscoin_versions'

    has_many :cost_options, :class_name => 'Smscoin::CostOption'

    def self.get_remote_data(url)
      #unfortunately Smscoin's HEAD is useless - its timestamps are always new
      txt = `curl #{url}` #surprisingly, no httpclient nor open-uri didn't work here. httpclient gave HTTPClient::KeepAliveDisconnected
      txt.gsub!(/^.*?\[/, '[') # remove variable assignment at beginning
      return txt, ActiveSupport::JSON.decode(txt)
    rescue Exception => e
      AdminNotifier.async_deliver_admin_alert("Error getting JSON from #{JSON_RU_URL} to update SmsCoin cost options: #{e.inspect}")
      return nil
    end

    def self.current
      self.last(:conditions => {:finished => true})
    end
    
    def self.check_remote(force_load = false)
      txt, data_eng = get_remote_data(JSON_ENG_URL)
      return unless txt
      md5 = Digest::MD5.hexdigest(txt)
      current = self.current
      if force_load || !current || current && md5 != current.cached_data_digest
        v = self.create!(:json => txt, :last_checked_at => Time.now, :cached_data_digest => md5)
        CostOption.import(data_eng, v.id)
        v.update_attribute(:finished, true)
        current = self.current
        @@cached_options = current.cost_options.to_a
        @@cached_version_id = v.id
        throwaway, data_ru = get_remote_data(JSON_RU_URL)
        self.countries.each do |code, name|
          CostOption.set_local_names(code, data_ru, 'ru')
        end
        @@cached_options = current.cost_options.reload.to_a
      else
        current.update_attribute(:last_checked_at, Time.now)
      end
      current
    end

    def self.refresh_cached_options_maybe
      @@cached_options ||= nil
      @@cached_version_id ||= nil

      current = self.current
      unless current
        current = check_remote
        AdminNotifier.async_deliver_admin_alert("Cannot obtain any SmsCoin cost options!") and return unless current
      end

      @@cached_options = nil if !current || @@cached_version_id != current.id
      if current
        @@cached_options ||= current.cost_options.to_a
        @@cached_version_id = current.id
      end
    end

    def self.cost_options
      refresh_cached_options_maybe
      @@cached_options
    end

    def self.maybe_filter_options(cos, filters = {})
      cos = cos.select {|o| o.gross_usd >= filters[:min_gross_usd]} if filters[:min_gross_usd]
      cos
    end

    def self.countries(filters = {})
      cos = cost_options
      cos = maybe_filter_options(cos, filters)
      all = (cos.map {|o| [o.country_code, o.country_name]}).uniq.sort {|a, b| a[1] <=> b[1]}
      first = [%w(RU BY UA), %w(AZ AM GE KZ KG LV LT EE)].map {|codes| codes.map {|code| all.find {|x| x[0] == code}}.compact}
      first[1] = first[1].sort {|a, b| a[1] <=> b[1]}
      (first[0] + first[1]) | all
    end

    def self.country_providers(country, filters = {})
      cos = cost_options.select {|o| o.country_code == country}
      cos = maybe_filter_options(cos, filters)      
      cos.map {|o| [country, o.provider_code, o.provider_name]}.uniq
    end

    def self.provider_options(country, provider, filters = {})
      cos = cost_options.select {|o| o.country_code == country && o.provider_code == provider}
      maybe_filter_options(cos, filters)
    end

    def self.guess_gross(net_usd)
      options = cost_options.select {|o| CostOption.equal_costs?(o.net_usd, net_usd)}
      log.debug "Smscoin gross guesser: found #{options.size} options with given net #{net_usd.to_f}"
      unless options.blank?
        return options[0].gross_usd
      end
      nil
    end

    def self.remove_old_cost_options
      CostOption.delete_all(['version_id < ?', current.id - 2]) if current
    end
  end
end