require File.dirname(__FILE__) + '/../spec_helper'

describe EncodingDetector do
  {'cyrillic-win' => ['windows-1251', 'Доминирование'],
    'cyrillic-utf' => ['UTF-16LE', '﻿Ещё Один Раз'],
    'latinic' => ['ascii', 'Country Girl'],
    'porto' => ['windows-1252', 'Você']}.each do |name, info|
    
    it "should detect strings in %s" % name do
      encoding, result = *info
      filename = name + '.yml'
      data = YAML.load_file("#{RAILS_ROOT}/test/fixtures/encoding/#{filename}")
      e = EncodingDetector.instance.detect(data)
      e.should == encoding
      decoded = EncodingDetector.instance.decode(data)
      decoded.should == result
    end
  end
end