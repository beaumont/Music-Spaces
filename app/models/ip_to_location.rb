class IpToLocation < ActiveRecord::Base
  REGION_CODE_DEFAULT = 'OTHER'
  COUNTRY_CODE_TO_REGION_CODE = {
    'US' => 'NA',
    'CA' => 'NA',
    'FR' => 'EU',
    'GR' => 'EU',
    'RU' => 'RU'
  }
  USSR_COUNTRY_CODES = ["RU", "UA", "BY", "GE", "MD", "AM", "AZ", "KZ", "UZ", "TM", "KG", "TJ", "EE", "LV", "LT"]

  def self.get_region(ip)
    i = ip2int(ip)
    r = first(:conditions => "from_ip < #{ i }",
              :order => 'from_ip desc'
             )
    if (r && r.to_ip > i)
      r.region_code = COUNTRY_CODE_TO_REGION_CODE[r.country_code]
      r
    else
      nil
    end
  end

  def self.ip_from_ussr?(ip)
    region = get_region(ip)
    region.nil? or USSR_COUNTRY_CODES.include?(region.country_code)
  end

  def region_code
    @region_code.nil? ? REGION_CODE_DEFAULT : @region_code
  end

  def region_code=(rc)
    @region_code = rc
  end

  private

  def self.ip2int(ip)
    is = ip.split('.')
    acc = 0
    is.each{|i| acc = acc*256 + i.to_i}
    
    acc
  end
end
