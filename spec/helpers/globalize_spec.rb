require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Globalize' do

  before :each do
    I18n.locale = 'ru'
    I18n.backend.instance_eval {init_translations}
  end

  it "trying to translate string with ellipsis shouldn't blow" do
    'one..two'.t
  end
  
  it "fixture should be loaded" do
    globalize_translations(:sending).tr_key.should == 'Sending...'
  end

  [
    [{"Sending..." => 'Отправка...'}, 'Translation strings with dots'],
    [{[x = "%d comments", 0] => '0 комментариев'}, 'pluralization: 0'],
    [{[x, 1] => '1 комментарий'}, 'pluralization: 1'],
    [{[x, 2] => '2 комментария'}, 'pluralization: 2'],
    [{[x, 5] => '5 комментариев'}, 'pluralization: 5'],
    [{[x, 11] => '11 комментариев'}, 'pluralization: 11'],
    [{[x, 21] => '21 комментарий'}, 'pluralization: 21'],
  ].each do |in_out, name|
    it "%s should work" % name do
      input, output = in_out.to_a[0]
      #puts 'keys: %s' % I18n.backend.instance_eval {translations}[:ru].keys.inspect
      #puts ':sql: %s' % I18n.backend.instance_eval {translations}[:ru][:sql]
      if input.is_a?(Array)
        string, *params = input
        (string / params).should == output
      else
        input.t.should == output
      end
    end
  end

  [
    {1 => 'день'},
    {2 => 'дня'},
    {[5, 6] => 'дней'}, #6 is 5 in time_ago_in_words for some reason
  ].each do |in_out|
    input, output = in_out.to_a[0]
    if input.is_a?(Array)
      days, input = input
    else
      days = input
    end
    it "time_ago_in_words should work for %d days ago" % days do
      time_ago_in_words(Time.now - input.days).should =~ Regexp.new(output)
    end
  end
  
end