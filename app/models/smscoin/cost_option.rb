#
#  create_table "smscoin_cost_options", :force => true do |t|
#    t.column "version_id",       :integer,                                 :default => 0, :null => false
#    t.column "country_name",     :string
#    t.column "country_name_ru",  :string
#    t.column "country_code",     :string
#    t.column "local_gross",      :decimal,  :precision => 11, :scale => 2
#    t.column "gross_usd",        :decimal,  :precision => 11, :scale => 2
#    t.column "net_usd",          :decimal,  :precision => 11, :scale => 2
#    t.column "profit",           :decimal,  :precision => 11, :scale => 2
#    t.column "currency",         :string
#    t.column "provider_code",    :string
#    t.column "provider_name",    :string
#    t.column "provider_name_ru", :string
#    t.column "created_at",       :datetime,                                               :null => false
#  end
#
require 'digest/md5'
module Smscoin
  class CostOption < ActiveRecord::Base
    set_table_name 'smscoin_cost_options'
    translates :country_name, :provider_name, :base_as_default => true

    def self.import_option(country_en, version_id)
      I18n.with_locale('en') do
        option = CostOption.new(:version_id => version_id,
                                :country_name => country_en['country_name'],
                                :country_code => country_en['country'],
                                :local_gross => country_en['price'],
                                :gross_usd => country_en['usd'],
                                :currency => country_en['currency'],
                                :provider_name => country_en['name'],
                                :provider_code => country_en['code'],
                                :profit => country_en['profit']
        )
        option[:net_usd] = (option[:gross_usd] * country_en['profit']).floor.to_f / 100
        option.save!
      end
    end
    
    def self.import_country_providers(country_en, providers_en, version_id)
      country_en.delete(providers_en)
      providers_en.each do |provider_en|
        import_option(provider_en.merge(country_en), version_id)
      end
    end
    
    def self.import(data_en, version_id)
      data_en.each_with_index do |country_en, idx|
        begin
          raise "country_en appeared to be string (hash expected): #{country_en.inspect}" if country_en.is_a?(String)
          providers_en = country_en.keys.find {|key| key.is_a?(Array) && key.size > 0}
          if providers_en
            import_country_providers(country_en, providers_en, version_id)
          else
            import_option(country_en, version_id)
          end
        rescue => e
          raise "Failed importing country #{idx}: #{e.inspect}"
        end
      end
    end

    def self.set_local_names(country_code, local_data, lang_suffix)
      country_data = local_data.find {|c| c['country'] == country_code}
      self.update_all(["country_name_#{lang_suffix} = ?", country_data['country_name']], ['country_code = ?', country_code])
      providers_data = country_data.keys.find {|key| key.is_a?(Array) && key.size > 0}
      if providers_data
        providers_data.each do |provider|
          self.update_all(["provider_name_#{lang_suffix} = ?", provider['name']], ['country_code = ? and provider_code = ?', country_code, provider['code']])
        end
      end
    end

    def self.equal_costs?(net_usd, other_net_usd)
      (net_usd - other_net_usd).abs <= BigDecimal("0.01")
    end
  end
end