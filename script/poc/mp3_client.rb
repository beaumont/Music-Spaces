#head = open('3', "rb") {|io| io.read };
#log.debug "hoho: \n#{Base64.encode64(head)}";

require 'json'

head_size = 230000 #usually enough for id3v2 (but not always!)
tail_size = 2500 #3k for both tail and head
files = %w(track05) #%w(komba_bakh Kroshka_Lu_pronzayuschaya_serdtsa million no_tags russian_album_latinic_title russian_title_and_artist sleep_away)
data = files.map do |file|
  file_data = open("test/fixtures/upload/#{file}.mp3", "rb") {|io| io.read }
  [file_data[0..head_size-1], file_data[-tail_size..-1]] #head and tail of file
end;

heads = data.map {|head, tail| Base64.encode64(head)};
tails = data.map {|head, tail| Base64.encode64(tail)};

#decode_locally(heads, tails)

string = JSON.generate(:heads => heads, :tails => tails);
#string = CGI::escape(string)
log.debug("string: \n #{string}");
res = Net::HTTP.post_form(URI.parse('http://kroogi.av/uploader/load_id3_tags'), {'files_data'=>string});
new_data = res.body;

JSON.parse(new_data).each {|file_data| puts file_data.inspect; log.debug file_data.inspect}; nil
