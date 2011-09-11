# -*- encoding: utf-8 -*- 

require File.dirname(__FILE__) + '/../../spec_helper'

describe I18n, "Russian pluralization" do
  before(:each) do
    @hash = {}
    %w(one few many other).each do |key|
      @hash[key.to_sym] = key
    end
    @backend = I18n.backend
  end

  [
    1 => 'one',
    2 => 'few',
    3 => 'few',
    5 => 'many',
    10 => 'many',
    11 => 'many',
    21 => 'one',
    29 => 'many',
    131 => 'one',
    1.31 => 'other',
    2.31 => 'other',
    3.31 => 'other',
  ].each do |hash|
    hash.each do | from, to|
      it "should pluralize %s correctly" % from do
        @backend.send(:pluralize, :'ru', @hash, from).should == to
      end
    end
  end
end