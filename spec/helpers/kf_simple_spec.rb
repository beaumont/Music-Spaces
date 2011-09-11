class Helper
  include ApplicationHelper
  include ActionView::Helpers::SanitizeHelper
  extend ActionView::Helpers::SanitizeHelper::ClassMethods
end

describe 'kf_simple' do

  before :each do
    @h = Helper.new
  end

  [[{(x = "a=b") => x}, x],
    [{(x= '<kroogi user="joe"/>') =>
          "<a href=\"http://joe.kroogi.test:3000\"><img src=\"/images/kruser.png\" /> joe</a>"}, x],
    [{(x = '<a href="blah">x</a>') => x}, 'html link tag'],
    [{(x = '<span class="hello">aaa</span>') => x}, 'span tag'],
    [{(x = "one\ntwo") => "one<br />two"}, 'plain linebreak converting'],
    [{(x = "first<br />second") => x}, x],
    [{(x = "<span>hello</span> world") => x}, x],
    [{(x = "first<br />") => x}, x],
    [{(x = "<span>hello</span><br />world") => x}, x],
    #[{(x = "> one\n\ntwo") => "<blockquote>\n<p>one<br /></p>\n</blockquote>\n\n<p>two</p>"}, "quote"],
    #[{(x = "some text\n\n> quote one\n\nreply to one\n\n> quoute two\n\nreply to two\n\nsomething else") => "some text<br /></p>\n\n<blockquote>\n<p>quote one<br /></p>\n</blockquote>\n\n<p>reply to one<br /></p>\n\n<blockquote>\n<p>quoute two<br /></p>\n</blockquote>\n\n<p>reply to two<br /></p>\n\n<p>something else"}, "quote in the middle of text"],
    [{(ref = "http://one.com"; x = "hello %s " % ref) => 'hello <a href="%s">%s</a>' % [ref, ref]}, "plain HTTP link resolving 1"],
    [{(ref = "www.one.com"; x = 'hello <a href="http://%s">%s</a>' % [ref, ref]) => 'hello <a href="http://%s">%s</a>' % [ref, ref]}, "existing 'a href' markup"],
    [{(ref = "www.one.com"; x = "hello %s " % ref) => 'hello <a href="http://%s">%s</a>' % [ref, ref]}, "plain HTTP link resolving 2"],
    #[{(ref = "http://one.com"; x = "hello <%s> " % ref) => 'hello <a href="%s">%s</a>' % [ref, ref]}, "HTTP link resolving - Markdown simplified syntax"],
    #[{(ref = "http://one.com"; x = "hello [link](%s) " % ref) => 'hello <a href="%s">link</a>' % [ref]}, "HTTP link resolving - Markdown full syntax"],
    [{" www.one.com\n http://one.com" => "<a href=\"http://www.one.com\">www.one.com</a><br /> <a href=\"http://one.com\">http://one.com</a>"}, "2 links with linebreak and space"],
    [{" www.one.com\n http://one.com\n http://one.com.plus" => "<a href=\"http://www.one.com\">www.one.com</a><br /> <a href=\"http://one.com\">http://one.com</a><br /> <a href=\"http://one.com.plus\">http://one.com.plus</a>"}, "3 links with linebreaks"],
    [{x = %Q{some text\n<a href="http://one.com">http://one.com</a>} =>
          "some text<br /><a href=\"http://one.com\">http://one.com</a>"},
      "some text followed by linebreak and html link"],
    [{"hello\nhttp://www.youtube.com/watch?v=t6mVgiXhWDY\nand\nhttp://www.youtube.com/watch?v=MW4O-kcwHjU&feature=related\n" =>
            youtube_links_with_linebreaks = "hello<br /><a href=\"http://www.youtube.com/watch?v=t6mVgiXhWDY\">" +
                    "http://www.youtube.com/watch?v=t6mVgiXhWDY</a>" +
                    "<br />and<br /><a href=\"http://www.youtube.com/watch?v=MW4O-kcwHjU&amp;feature=related\">" +
                    "http://www.youtube.com/watch?v=MW4O-kcwHjU&feature=related</a><br />"},
     "2 youtube links with linebreaks"],
    [{"hello http://www.youtube.com/watch?v=t6mVgiXhWDY and http://www.youtube.com/watch?v=MW4O-kcwHjU&feature=related" =>
            "hello <a href=\"http://www.youtube.com/watch?v=t6mVgiXhWDY\">http://www.youtube.com/watch?v=t6mVgiXhWDY</a> " +
                    "and <a href=\"http://www.youtube.com/watch?v=MW4O-kcwHjU&amp;feature=related\">" +
                    "http://www.youtube.com/watch?v=MW4O-kcwHjU&feature=related</a>"},
     "2 youtube links without linebreaks"],
    [{"hello\n<a href=\"http://www.youtube.com/watch?v=t6mVgiXhWDY\">http://www.youtube.com/watch?v=t6mVgiXhWDY</a>\n" +
            "and\n<a href=\"http://www.youtube.com/watch?v=MW4O-kcwHjU&feature=related\">http://www.youtube.com/watch?v=MW4O-kcwHjU&feature=related</a>\n" =>
            youtube_links_with_linebreaks},
     "2 raw html youtube links with linebreaks"],

  ].each do |in_out, name|
    it "case '%s' should work" % name do
      input, output = in_out.to_a.flatten
      input = input.dup #otherwise it's frozen
      @h.kf_simple(input).should == output
    end
  end

  [[{(x= 'my long text <kroogi-cut text="I have more"> more text more text more </kroogi-cut>') =>
          "my long text <a href=\"#\" id=\"link225157900\" onclick=\"toggleDiv(225157900, 'link225157900');return false\">I have more</a><div id=\"225157900\" style=\"display: none;\"> more text more text more </div>"}, x],
    [{(x= 'my long text <kroogi-cut> more text more text more </kroogi-cut>') =>
          "my long text <a href=\"#\" id=\"link225157900\" onclick=\"toggleDiv(225157900, 'link225157900');return false\">More...</a><div id=\"225157900\" style=\"display: none;\"> more text more text more </div>"}, x],
  ].each do |in_out, name|
    it "case '%s' should work" % name do
      input, output = in_out.to_a.flatten
      input = input.dup #otherwise it's frozen
      @h.kf_simple(input,
        {:characters => 1000,
          :tags => %w(a div),
          :attributes => %w(id onclick style)}).should match(/(.*)<a\shref\=\"#\"\sid=\"link(-?)\d*\"\sonclick\=\"(.*)/)
    end
  end

  it "should not modify text when no tags" do
    youtube_links_with_linebreaks = @h.kf_simple('Any text')
    youtube_links_with_linebreaks.should == 'Any text'
  end

  it "should not remove post if tags present" do
    youtube_links_with_linebreaks = @h.kf_simple('morning <kroogi user="joe"/> more text')
    youtube_links_with_linebreaks.should == 'morning <a href="http://joe.kroogi.test:3000"><img src="/images/kruser.png" /> joe</a> more text'
  end

  it "should allow to bypass specified tag" do
    youtube_links_with_linebreaks = @h.kf_simple('my long text <kroogi-cut text="I have more"> more text more text more </kroogi-cut>',
      {:ignore => 'kroogi-cut',
        :tags => %w(a div),
        :attributes => %w(id onclick style)})
    youtube_links_with_linebreaks.should == 'my long text  more text more text more'
  end

  it "should allow parsing of well formed <UL> tags" do
    text = "<ul>"
    text << "<li>Option 1</li>"
    text << "<li>Option 2</li>"
    text << "<li>Option 3</li>"
    text << "<ul>"
    output = @h.kf_simple(text)
    output.should == '<ul><li>Option 1</li><li>Option 2</li><li>Option 3</li><ul></ul></ul>'
  end

  it "should allow parsing of well formed <UL> tags and kroogi user tags" do
    text = "<ul>"
    text << '<li><kroogi user="joe"/></li>'
    text << '<li><kroogi user="joe"/></li>'
    text << "<li>Option 3</li>"
    text << "<ul>"
    output = @h.kf_simple(text)
    output.should == '<ul><li><a href="http://joe.kroogi.test:3000"><img src="/images/kruser.png" /> joe</a></li><li><a href="http://joe.kroogi.test:3000"><img src="/images/kruser.png" /> joe</a></li><li>Option 3</li><ul></ul></ul>'
  end

  #bug ref #4173
  it "should allow inline parsing of <UL> tags and kroogi user tags" do
    text = '<ul><li><kroogi user="joe"/></li><li><kroogi user="chief"/></li><li><kroogi user="I dont exist"/></li></ul>'
    output = @h.kf_simple(text)
    output.should == '<ul><li><a href="http://joe.kroogi.test:3000"><img src="/images/kruser.png" /> joe</a></li><li><a href="http://chief.kroogi.test:3000"><img src="/images/kruser.png" /> chief</a></li><li> <a href="#" title="User no longer exists"><img src="/images/project.png" /> I dont exist</a></li></ul>'
  end

  #bug ref #4172
  it "should not remove pretext if tags present" do
    youtube_links_with_linebreaks = @h.kf_simple('morning <kroogi user="joe"/>')
    youtube_links_with_linebreaks.should == 'morning <a href="http://joe.kroogi.test:3000"><img src="/images/kruser.png" /> joe</a>'
  end

  it "should play well with both tags present" do
    input = 'morning <kroogi user="joe"/> my long text <kroogi-cut text="I have more"> more text more text more </kroogi-cut>'
    youtube_links_with_linebreaks = @h.kf_simple(input,
         {:characters => 1000,
          :tags => %w(a div),
          :attributes => %w(id onclick style)}).should match(/(.*)<a\shref\=\"#\"\sid=\"link(-?)\d*\"\sonclick\=\"(.*)/)
  end

  it "kroogi cut should just work" do
    input = 'my long text <kroogi-cut text="I have more"> more text more text more </kroogi-cut>'
    youtube_links_with_linebreaks =  @h.kf_simple(input,
         {:characters => 1000,
          :tags => %w(a div),
          :attributes => %w(id onclick style)}).should match(/(.*)<a\shref\=\"#\"\sid=\"link(-?)\d*\"\sonclick\=\"(.*)/)
  end

  it "kroogi cut ending tag should be optional" do
    input = 'my long text <kroogi-cut /> more text more text more'
    youtube_links_with_linebreaks =  @h.kf_simple(input,
         {:characters => 1000,
          :tags => %w(a div),
          :attributes => %w(id onclick style)}).should match(/(.*)<a\shref\=\"#\"\sid=\"link(-?)\d*\"\sonclick\=\"(.*)/)
  end

   it "kroogi cut ending tag with custom text should be optional" do
    input = 'my long text <kroogi-cut text="I have more" /> more text more text more'
    youtube_links_with_linebreaks =  @h.kf_simple(input,
         {:characters => 1000,
          :tags => %w(a div),
          :attributes => %w(id onclick style)}).should match(/(.*)<a\shref\=\"#\"\sid=\"link(-?)\d*\"\sonclick\=\"(.*)/)
  end

  it "should convert new line to <br /> even if kroogi user tag present" do
    text = 'morning <kroogi user="decorator"> cool user</kroogi>'
    text << "\n"
    text << "next line"
    output = @h.kf_simple(text)
    output.should == 'morning  <a href="#" title="User no longer exists"><img src="/images/project.png" />  cool user</a><br />next line'
  end

  it "kroogi_format should not excerpt if kroogi-cut present" do
    text = "1977,promo clip,with superior quality,of the video and the sound Johnny Rotten"
    text << " Vocals Steve Jones - Guitar Paul Cook - Drums Sid Vicious - Bass Lyrics: God save the queen "
    text << "before cut <kroogi-cut> text after cut </kroogi-cut>"
    text << "Her fascist regime It made you a moron A potential H bomb God save the queen She ain't no "
    text << "human being There i...1977,promo clip,with superior quality,of the video and the sound "
    text << "Johnny Rotten - Vocals Steve Jones"
    youtube_links_with_linebreaks = @h.kf_simple(text,
      {:characters => 50,
        :conditional_excerpt => true,
        :ending => "... (" +  link_to("Read More".t, "#" ) +')',
        :tags => %w(a div),
        :attributes => %w(id onclick style)})
    youtube_links_with_linebreaks.should_not match(/.*\n?Read More/)
  end


  it "tags shouldn't break when excerpting" do
    @h.kf_simple('one two<a href="x">x</a>', :characters => 11).should == 'one two...' #removing trailing part of tag from 'one two<a h'
    @h.kf_simple('one two<strong>x y</strong>', :characters => 18).should == 'one two<strong>x...</strong>' #autoclosing 'one two<strong>x'
  end

  it "should not autocut if text without HTML is inferior of cut lenght provided" do
    text = "<a href=\"#\">Roomer</a> says, Friday is not the best day to annonce things"
    text << "<object width=\"500\" height=\"282\"> <param name=\"wmode\" value=\"transparent\" /> <param name=\"movie\" value=\"http://kroogi.com/flash/tps.swf\" /> <param name=\"flashvars\" value=\"config=http://kroogi.com/tps_embed/config/940795.xml?locale=ru\" />"
    text << "<param name=\"allowScriptAccess\" value=\"always\" /> <embed src=\"http://kroogi.com/flash/tps.swf\" type=\"application/x-shockwave-flash\" width=\"500\" height=\"282\" flashvars=\"config=http://kroogi.com/tps_embed/config/940795.xml?locale=ru\" "
    text << "allowScriptAccess=\"always\" wmode=\"transparent\"> </embed> </object>"
    text_with_embed_flash = @h.kf_content(text, {
              :characters => 400,
              :conditional_excerpt => true,
              :inplace_link => true
            })
    text_with_embed_flash.should_not match(/.*\n?'...'/)
  end

  it "should not cut when <nocut> tag is present" do
    text = "<nocut>Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit..."
    text << "There is no one who loves pain itself, who seeks after it and wants to have it, simply because it is pain..."
    text << "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, "
    text << "when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into"
    text << "electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, "
    text << "and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."

    text_with_nocut_tag = @h.kf_content(text, {
              :characters => 400,
            })
    text_with_nocut_tag.should_not match(/.*\n?'...'/)
    text_with_nocut_tag.size.should == text.gsub!('<nocut>', '').size
  end

end