require File.dirname(__FILE__) + '/../spec_helper'

include AuthenticatedTestHelper

describe SubmitController do
  integrate_views
  include SpecHelpersMixin


  before :each do
    Locale.set("en")
    @current_user = users(:chief)
    controller.stub!(:current_user).and_return(@current_user)
  end

  it "new album page should work for pricable user" do
    @controller.instance_eval do
      @user = current_user
      prepare_new_album
      @content.should_receive(:can_have_prices_set?).any_number_of_times.and_return(true)
    end
    get :album, :user_id => @current_user.id
    response.should be_success
  end

  it "new music album page should work" do
    get :music_album, :user_id => @current_user.id
    response.should be_success
    #assert_select 'div h1', 'New Music Album'
    assert_select 'div.tabs_container'
  end

  def added_downloadable_folder_params
    { "new"=>true,
      "commit"=>"",
      "downloadable"=>"1",
      "file_bundle"=>[{"uploaded_data"=>fixture_file_upload("upload/songs.zip")}],
      "content"=>[{"artist"=>"",
      "show_donation_button"=>"1",
      "relationshiptype_id"=>"-2",
      "amount_required_for_circle_invite_eur"=>"",
      "title"=>"plain folder",
      "donation_button_label"=>"",
      "message_to_donors_ru"=>"",
      "title_ru"=>"",
      "donation_button_label_ru"=>"",
      "amount_required_for_circle_invite_rur"=>"",
      "amount_required_for_circle_invite_usd"=>"",
      "is_in_startpage"=>"1",
      "description"=>"",
      "is_in_gallery"=>"true",
      "circle_to_invite_to"=>"",
      "year"=>"",
      "tag_list"=>"",
      "message_to_donors"=>"",
      "user_id"=>@current_user.id,
      "amount_usd"=>"",
      "artist_ru"=>"",
      "description_ru"=>""},
      {"show_donation_button"=>"0",
      "is_in_startpage"=>"0",
      }],
      :terms => {"require_terms_acceptance"=>"1",
                 "terms"=>"",
                 "terms_ru"=>"",
                 },
      "cover_art"=>{"uploaded_data"=>""}}
  end

  it "downloadable album creation should not blow when terms required" do
    post :add_album, added_downloadable_folder_params

    assert_no_errors(assigns(:content))
    flash[:error].should == nil
    response.should be_redirect
  end

  it "downloadable album creation should not blow when terms are disabled" do
    data = added_downloadable_folder_params
    data.delete(:terms)
    post :add_album, data

    assert_no_errors(assigns(:content))
    flash[:error].should == nil
    response.should be_redirect
  end

  it "album creation should not blow when changing one's mind about its downloadability" do
    post :add_album, added_downloadable_folder_params.merge("downloadable"=>nil)

    assert_no_errors(assigns(:content))
    flash[:error].should == nil
    response.should be_redirect
    assigns(:content).class.name.should == Album.name
  end

  it "non-downloadable album creation should work" do
    post :add_album,
      "terms_type"=>"custom",
      "new"=>true,
      "commit"=>"",
      "file_bundle"=>[{"uploaded_data"=>""}],
      "content"=>[{"artist"=>"",
      "show_donation_button"=>"1",
      "relationshiptype_id"=>"-2",
      "amount_required_for_circle_invite_eur"=>"",
      "title"=>"plain folder",
      "donation_button_label"=>"",
      "message_to_donors_ru"=>"",
      "title_ru"=>"",
      "donation_button_label_ru"=>"",
      "amount_required_for_circle_invite_rur"=>"",
      "terms_ru"=>"",
      "amount_required_for_circle_invite_usd"=>"",
      "is_in_startpage"=>"1",
      "description"=>"",
      "is_in_gallery"=>"true",
      "circle_to_invite_to"=>"",
      "year"=>"",
      "terms"=>"",
      "tag_list"=>"",
      "message_to_donors"=>"",
      "user_id"=>@current_user.id,
      "amount_usd"=>"",
      "require_terms_acceptance"=>"0",
      "artist_ru"=>"",
      "description_ru"=>""},
      {"show_donation_button"=>"0",
      "is_in_startpage"=>"0"}],
      "cover_art"=>{"uploaded_data"=>""}
    assert_no_errors(assigns(:content))
    response.should be_redirect
    flash[:error].should == nil
    assigns(:content).class.name.should == Album.name
  end

  it "music album creation should work" do
    post :add_music_album,
      {"commit"=>"",
      "downloadable"=>"1",
      "content"=>[{"artist"=>"",
      "show_donation_button"=>"0",
      "relationshiptype_id"=>"-2",
      "amount_required_for_circle_invite_eur"=>"",
      "title"=>"",
      "donation_button_label"=>"Download",
      "message_to_donors_ru"=>"",
      "title_ru"=>"",
      "donation_button_label_ru"=>"",
      "amount_required_for_circle_invite_rur"=>"",
      "album_id"=>"",
      "amount_required_for_circle_invite_usd"=>"",
      "is_in_startpage"=>"1",
      "description"=>"",
      "is_in_gallery"=>"true",
      "circle_to_invite_to"=>"",
      "year"=>"",
      "tag_list"=>"",
      "message_to_donors"=>"",
      "user_id"=>@current_user.id,
      "amount_usd"=>"",
      "artist_ru"=>"",
      "description_ru"=>""},
      {"is_in_startpage"=>"0"}],
      "cover_art"=>{"uploaded_data"=>""}}

    assert_no_errors(assigns(:content))
    assigns(:content).bundles.should be_blank
    response.should be_redirect
    flash[:error].should == nil
    assigns(:content).class.name.should == MusicAlbum.name
  end

  it "should accept new announcements" do
    post :add_announcement, {
      "announcement"=>{},
      "content"=>{
        "show_donation_button"=>"0",
        "relationshiptype_id"=>"-2",
        "reason_for_kroogi_pass_ru"=>"",
        "post_ru"=>"this is not english",
        "donation_button_label_ru"=>"",
        "title_ru"=>"russian man",
        "priority"=>"0",
        "is_in_startpage"=>"1",
        "reason_for_kroogi_pass"=>"",
        "tag_list"=>"tag, blue, green",
        "amount_rur"=>"",
        "post"=>"this is english",
        "amount_usd"=>"",
        "donation_button_label"=>"",
        "title"=>"english man",
      },
      "user_id"=> @current_user.id
    }
    assert_no_errors(assigns(:content))
    flash[:error].should == nil
    response.should be_redirect
  end

  it "add project page should work" do
    @current_user = users(:ian_curtis)
    controller.stub!(:current_user).and_return(@current_user)
    album = contents(:joydivisions_featured_album)
    get :project, :user_id => @current_user.id, :for_album => album.id
    response.should be_success
    assigns(:content).is_a?(ProjectAsContent).should == true
  end

  def add_project(project_name, collection, actor, options = {})
    user = users(actor)
    controller.stub!(:current_user).and_return(user)
    container_project = users(collection)
    user.is_self_or_owner?(container_project).should == true
    post :add_project, "content"=>[
      {"description"=>"",
      "body_project_name"=>project_name,
      "tag_list"=>"",
      "description_ru"=>""}],
      "user_id"=>container_project.id

    if options[:require_success]
      assert_no_errors(assigns(:content))
      flash[:error].should == nil
      response.should be_redirect
      assigns(:content).user_id.should == container_project.id
      assigns(:content).body_project.login.should == project_name
    end

  end

  it "adding project to collection should work" do
    add_project('magazine', 'kroogi-music', :joe, :require_success => true)
  end

  it "adding project to collection should ignore heading/trailing spaces in name" do
    add_project('  magazine   ', 'kroogi-music', :joe, :require_success => true)
  end

  it "adding project to collection should add it to showcase" do
    add_project('magazine', 'kroogi-music', :joe)
    content = assigns(:content)
    content.featured_album.album_contents.should_not be_empty
    content.featured_album.album_contents.include?(content).should be_true
  end

  #it makes sense to test validations at controller level because controller
  #  does some sideeffects that should be passed testing as well - so this are
  #  kind of integrational tests
  it "adding project to collection should validate name presence" do
    add_project('', 'kroogi-music', :joe)
    assert_errors(assigns(:content), :match => /name/)
  end

  it "adding project to collection should validate project existence" do
    add_project('inexistent', 'kroogi-music', :joe)
    assert_errors(assigns(:content), :match => /name/)
  end

  it "adding project to collection should reject duplicates" do
    add_project('joydivision', 'kroogi-music', :joe)
    assert_errors(assigns(:content), :match => /already/)
  end


  it "adding project to collection should reject cycles - distance 0" do
    add_project('kroogi-music', 'kroogi-music', :joe)
    assert_errors(assigns(:content), :match => /itself/)
  end

  it "adding project to collection should reject cycles - distance 1" do
    #pre-requisite
    ProjectAsContent.find_ancestory_chain_with(users('kroogi-music').id,
      users(:dub).id).should == [users('kroogi-music').id, users(:dub).id]

    add_project('kroogi-music', 'dub', :joe)
    assert_errors(assigns(:content), :match => /circular/)
  end

  it "adding project to collection should reject cycles - distance 2" do
    #pre-requisite
    ProjectAsContent.find_ancestory_chain_with(users('kroogi-music').id,
      users('ambient-dub').id).should == [users('kroogi-music').id,
      users(:dub).id, users('ambient-dub').id]

    add_project('kroogi-music', 'ambient-dub', :joe)
    assert_errors(assigns(:content), :match => /circular/)
  end

  it "adding project to collection should add to collection's public activity" do
    user = users('kroogi-music')
    before = user.public_activities.size
    add_project('magazine', user.login, :joe)
    user.reload
    user.public_activities.size.should == before + 1
  end

  it "project update should work" do
    user = users(:joe)
    controller.stub!(:current_user).and_return(user)
    project = contents(:rock_as_kroogimusic_content)
    post :update,
      "content"=>{project.id => {"id"=>project.id,
      "_description"=>"Nicoletta Braschi (born 10 August 1960) is an Italian actress",
      "description_ru"=>"Раиса Исаевна Линцер (3 декабря 1905, Кировоград"}},
      "user_id"=>@current_user.id
    assert_no_errors(assigns(:content))
    response.should be_redirect
    flash[:error].should == nil
  end

  def image_upload_params(user)
    {"commit"=>"",
     "ownership"=>"me",
     "content"=>{"uploaded_data"=>{"1"=>fixture_file_upload("upload/love.png")},
       "id"=>"",
       "tag_list"=>"",
       "cat_id"=>Content::CATEGORIES[:image][:id],
       "owner"=>"",
       "user_id"=>user.id},
     "for_album"=>""}
  end

  it "image upload should work" do
    post :upload, image_upload_params(@current_user)
    flash[:error].should == nil
  end

  it "image upload should generate right activities" do
    user = set_current_user(:ian_curtis, :actor => users(:joy_division))
    post :upload, image_upload_params(user.actor)
    flash[:error].should == nil
    content = assigns(:content)
    Activity.for_content(content).count.should == 1 #JD
    FeedEntryActivity.find(:all, :conditions => {:content_id => content.id, :content_type => 'Content'}).count.should == 2 #Ian as host, and Joe as Interested
  end

   it "avatar upload should work and set as default if param present" do
    post :upload,
      {"commit"=>"",
       "ownership"=>"me",
       "set_as_default"=>"true",
       "content"=>{"uploaded_data"=>{"1"=>fixture_file_upload("upload/love.png")},
         "id"=>"",
         "tag_list"=>"",
         "cat_id"=>Content::CATEGORIES[:avatar][:id],
         "owner"=>"",
         "user_id"=>@current_user.id},
       "for_album"=>""}
    @current_user.profile.avatar_id.should == assigns(:content).id
    flash[:error].should == nil
  end

  it "image upload should not work for wrong type" do
    post :upload,
      {"commit"=>"",
       "ownership"=>"me",
       "content"=>{"uploaded_data"=>{"1"=>fixture_file_upload("upload/million.mp3")},
         "id"=>"",
         "tag_list"=>"",
         "cat_id"=>Content::CATEGORIES[:image][:id],
         "owner"=>"",
         "user_id"=>@current_user.id},
       "for_album"=>""}
    flash[:error].should =~ /type/
  end

  def million_track_params(user = nil)
    user = @current_user unless user 
    {"uploaded_data"=>{"1"=>fixture_file_upload("upload/million.mp3")},
         "id"=>"",
         "tag_list"=>"",
         "cat_id"=>Content::CATEGORIES[:track][:id],
         "owner"=>"",
         "user_id"=>user.id}
  end

  it "track upload should work for showcase" do
    post :upload,
      {"commit"=>"",
       "ownership"=>"me",
       "content"=>million_track_params,
       "for_album"=>""}

    flash[:error].should == nil
    assigns(:content).title.should == 'Million'
  end

  it "track upload should generate right activities" do
    user = set_current_user(:ian_curtis, :actor => users(:joy_division))
    post :upload,
      {"commit"=>"",
       "ownership"=>"me",
       "content"=>million_track_params(user.actor),
       "for_album"=>""}

    flash[:error].should == nil
    content = assigns(:content)
    Activity.for_content(content).count.should == 1 #JD
    FeedEntryActivity.find(:all, :conditions => {:content_id => content.id, :content_type => 'Content'}).count.should == 2 #Ian as host, and Joe as Interested
  end

  it "track upload should work for album" do
    album = contents(:chiefs_sacred_album)
    album.relationshiptype_id.should_not == nil #albeit strange but pre-requisite for the case
    post :upload,
      {"commit" => "",
       "ownership" => "me",
       "content" => million_track_params,
       "for_album" => album.id}

    flash[:error].should == nil
    assigns(:content).albums.include?(album).should == true #it should belong to that album
    assigns(:content).title.should == 'Million'
  end

  it "track upload should work with complex case of tag encodings combination" do
    post :upload,
      {"commit"=>"",
       "ownership"=>"me",
       "content"=>million_track_params.merge("uploaded_data"=>{"1"=>fixture_file_upload("upload/russian_album_latinic_title.mp3")}),
       "for_album"=>""}
    flash[:error].should == nil
    assigns(:content).artist.should == 'Поёт Радионяня'
  end

  it "track upload should work with case when artist name looks like chinese but it's win1251" do
    post :upload,
      {"commit"=>"",
       "ownership"=>"me",
       "content"=>million_track_params.merge("uploaded_data"=>{"1"=>fixture_file_upload("upload/komba_bakh.mp3")}),
       "for_album"=>""}
    flash[:error].should == nil
    assigns(:content).artist.should == 'Комба БАКХ'
  end

  it "track upload should not add weird chars to title" do
    post :upload,
      {"commit"=>"",
       "ownership"=>"me",
       "content"=>million_track_params.merge("uploaded_data"=>{"1"=>fixture_file_upload("upload/komba-track12.mp3")}),
       "for_album"=>""}
    flash[:error].should == nil
    log.debug "assigns(:content).title = #{assigns(:content).title.chars[0].inspect}"
    assigns(:content).title.to_json.should == 'ПРО ВИНЦИЯ'.to_json
  end

  it "track upload should work with case when artist name looks like chinese but it's win1251 - 2samoleta case" do
    post :upload,
      {"commit"=>"",
       "ownership"=>"me",
       "content"=>million_track_params.merge("uploaded_data"=>{"1"=>fixture_file_upload("upload/Kroshka_Lu_pronzayuschaya_serdtsa.mp3")}),
       "for_album"=>""}
    flash[:error].should == nil
    assigns(:content).album.should == 'Когда поёт далекий друг'
  end

  it "track upload should work with 2 non-latinic fields" do
    post :upload,
      {"commit"=>"",
       "ownership"=>"me",
       "content"=>million_track_params.merge("uploaded_data"=>{"1"=>fixture_file_upload("upload/russian_title_and_artist.mp3")}),
       "for_album"=>""}
    flash[:error].should == nil
    assigns(:content).artist.should == 'Поёт Радионяня'
    assigns(:content).title.should == 'Миллион'
  end

  it "track upload should not work with file without tags" do
    post :upload,
      {"commit"=>"",
       "ownership"=>"me",
       "content"=>{"uploaded_data"=>{"1"=>fixture_file_upload("upload/no_tags.mp3")},
         "id"=>"",
         "tag_list"=>"",
         "cat_id"=>Content::CATEGORIES[:track][:id],
         "owner"=>"",
         "user_id"=>@current_user.id},
       "for_album"=>""}
    flash[:error].should =~ /tags/
  end

  it "track upload should not work with non-mp3s" do
    post :upload,
      {"commit"=>"",
       "ownership"=>"me",
       "content"=>{"uploaded_data"=>{"1"=>fixture_file_upload("upload/non_mp3.mp4")},
         "id"=>"",
         "tag_list"=>"",
         "cat_id"=>Content::CATEGORIES[:track][:id],
         "owner"=>"",
         "user_id"=>@current_user.id},
       "for_album"=>""}
    flash[:error].downcase.should =~ /only mp3s/
  end

  def edit_own_ma
    content = contents(:squarepusher_weird_album)
    controller.instance_eval {current_user}.is_self_or_owner?(content.user).should == true
    get :edit, :id => content
    response.should be_success
    assigns(:content).should_not be_nil
  end

  it "editing own music album should work" do
    edit_own_ma
    assert_select 'div.tabs_container'
  end

  it "edit MA page should have text fields in translation tabs block" do
    edit_own_ma
    assert_select '#tab_english_translation_1 input[type=text]'
  end

  it "updating own music album should work" do
    content = contents(:squarepusher_weird_album)
    controller.instance_eval {current_user}.is_self_or_owner?(content.user).should == true
    new_title = "x"
    content.title.should_not == new_title
    post :update,
            "content"=>{content.id=>{"relationshiptype_id"=>"-2",
            "title"=>new_title,
            "title_ru"=>"",
            "album_id"=>"",
            "id"=>content.id,
            "is_in_startpage"=>"1",
            "is_in_gallery"=>"1",
            "description"=>"",
            "tag_list"=>"",
            "user_id"=>@current_user.id,
            "description_ru"=>""}}
    response.should be_redirect
    content.reload
    content.title.should == new_title
  end

  def test_switching_non_dl_to_dl(override_params, override_content_params = {}, override_terms_params = {})
    content = contents(:comb_the_desert_album)
    controller.instance_eval {current_user}.is_self_or_owner?(content.user).should == true
    content.class.should == Album
    post :update,
            {"commit"=>"",
            "downloadable"=>"1",
            "file_bundle"=>[{"uploaded_data"=>fixture_file_upload("upload/love.png")}],
            "content"=>{content.id=>{"artist"=>"artist",
            "show_donation_button"=>"0",
            "relationshiptype_id"=>"-2",
            "amount_required_for_circle_invite_eur"=>"",
            "title"=>"",
            "donation_button_label"=>"Download",
            "message_to_donors_ru"=>"",
            "donation_button_label_ru"=>"",
            "title_ru"=>"",
            "amount_required_for_circle_invite_rur"=>"",
            "album_id"=>"",
            "is_in_startpage"=>"0",
            "id"=>content.id,
            "amount_required_for_circle_invite_usd"=>"",
            "description"=>"",
            "circle_to_invite_to"=>"",
            "is_in_gallery"=>"1",
            "year"=>"",
            "tag_list"=>"",
            "message_to_donors"=>"Thank you for your donation",
            "user_id"=>@current_user.id,
            "amount_rur"=>"",
            "amount_usd"=>"",
            "description_ru"=>""}.merge(override_content_params)},
            :terms => {
                    "require_terms_acceptance"=>"0",
                    "terms"=>"",
                    "terms_ru"=>"",
                    }.merge(override_terms_params),
            "cover_art"=>{"uploaded_data"=>fixture_file_upload("upload/love.png")}}.merge(override_params)
    flash[:error].should == nil
    response.should be_redirect
    content = Content.find(content.id)
    content.bundles.should_not be_empty
  end

  it "switching non-downloadable album to downloadable should work" do
    test_switching_non_dl_to_dl({})
  end

  it "switching non-downloadable album to downloadable should work when terms are disabled" do
    test_switching_non_dl_to_dl({:terms => nil})
  end

  it "switching non-downloadable album to downloadable with requiring terms should work" do
    test_switching_non_dl_to_dl({}, {}, {"require_terms_acceptance"=>"1", "terms" => 'hello!'})
  end

  it "switching downloadable album to non-downloadable should work" do
    content = contents(:chiefs_sacred_album)
    controller.instance_eval {current_user}.is_self_or_owner?(content.user).should == true
    content.class.should == FolderWithDownloadables
    post :update,
            {"commit"=>"",
            "file_bundle"=>[{"uploaded_data"=>""}],
            "content"=>{content.id=>{"artist"=>"artist",
            "show_donation_button"=>"0",
            "relationshiptype_id"=>"-2",
            "amount_required_for_circle_invite_eur"=>"",
            "donation_button_label"=>"Download",
            "message_to_donors_ru"=>"",
            "title"=>"",
            "donation_button_label_ru"=>"",
            "amount_required_for_circle_invite_rur"=>"",
            "title_ru"=>"",
            "album_id"=>"",
            "amount_required_for_circle_invite_usd"=>"",
            "is_in_startpage"=>"1",
            "id"=>content.id,
            "is_in_gallery"=>"1",
            "description"=>"",
            "circle_to_invite_to"=>"",
            "year"=>"0",
            "message_to_donors"=>"Thank you for your donation",
            "tag_list"=>"",
            "amount_rur"=>"",
            "user_id"=>@current_user.id,
            "amount_usd"=>"",
            "artist_ru"=>"artist",
            "description_ru"=>""}},
            :terms => {
                    "terms"=>"",
                    "require_terms_acceptance"=>"1",
                    },
            "cover_art"=>{"uploaded_data"=>""}}
    flash[:error].should == nil
    response.should be_redirect
    content = Content.find(content.id)
    content.class.should == Album
  end

  it "make_downloadable call for non-pricable content should advice to attach payment system" do
    @current_user = users(:chief)
    controller.stub!(:current_user).and_return(@current_user)
    get :make_downloadable, :id => contents(:squarepusher_weird_album).id
    response.should be_redirect
    assert_match /payment/, flash[:error], 'flash[:error] should mention payment systems'
  end

  def pretend_content_is_pricable(content_symbol)
    controller.should_receive(:load_content).any_number_of_times do
      content = contents(content_symbol)
      content.should_receive(:can_have_prices_set?).any_number_of_times.and_return(true)
      controller.instance_eval {@content = content}
      controller.send(:load_owner)
    end
  end

  def test_make_downloadable(fake_param)
    set_current_user(:ian_curtis)
    pretend_content_is_pricable(:joydivisions_closer_album)
    get :make_downloadable
    response.should be_success
  end

  it "make_downloadable call for pricable content should work" do
    test_make_downloadable nil
  end

  it "zip generation should work" do
    set_current_user(:ian_curtis)
    pretend_content_is_pricable(:joydivisions_closer_album)
    post :generate_zip #:joydivisions_closer_album will be loaded because of pretend_content_is_pricable
    response.should be_redirect
    flash[:success].should_not be_nil
    album = assigns[:content]
    album.reload
    album.show_donation_button.should == true
  end

  def test_moving_track(track, to_album)
    post :update, "content"=>{track.id=>{"show_donation_button"=>"0", "artist"=>"Poet Radionania", "album_ru"=>"",
                                       "relationshiptype_id"=>"-2", "title"=>"Millioncho", "uploaded_data"=>"",
                                       "title_ru"=>"", "album_id"=>to_album.id,
                                       "is_in_startpage"=>"0", "id"=>track.id,
                                       "description"=>"", "is_in_gallery"=>"0", "year"=>"", "tag_list"=>"",
                                       "genre"=>"", "album"=>"", "owner"=>track.owner, "artist_ru"=>"",
                                       "amount_usd"=>"", "description_ru"=>""}}
    assert_no_errors(assigns(:content))
    flash[:error].should == nil
    response.should be_redirect
    track = Content.find(track.id)
    track.albums.map {|a| '"%s"' % a.title}.join(', ').should =~ /#{to_album.title}/
  end

  it "moving MA's track to another MA should work" do
    set_current_user(:ian_curtis)
    test_moving_track(contents(:jd_closer_decades_track), contents(:joydivisions_substance_album))
  end

  it "moving MA's track to FWD should work" do
    set_current_user(:ian_curtis)
    test_moving_track(contents(:jd_closer_decades_track), contents(:joydivisions_up_folder))
  end

  it "moving FWD's track to MA should work" do
    set_current_user(:ian_curtis)
    test_moving_track(contents(:jd_up_insight_track), contents(:joydivisions_closer_album))
  end

  it "moving FWD's track to plain Album should work" do
    set_current_user(:ian_curtis)
    test_moving_track(contents(:jd_up_insight_track), contents(:ian_curtis_family_pictures_album))
  end

  it "moving FWD's track to another FWD should work" do
    set_current_user(:ian_curtis)
    test_moving_track(contents(:jd_up_insight_track), contents(:ian_curtis_videos_album))
  end

  {"plain album" => :ian_curtis_family_pictures_album, "FWD" => :joydivisions_up_folder, "MA" => :joydivisions_closer_album}.each do |case_name, content_symbol|
    it "deleting %s should work" % case_name do
      set_current_user(:ian_curtis)
      post :delete, :id => contents(content_symbol)
      response.should be_redirect
      assert_no_errors(assigns(:content))
      flash[:error].should == nil
    end
  end

  def add_music_params(track, container_album, content_params = {}, options = {})
    options.reverse_merge!(:check_albums => true)
    raise "track shouldn't be in any album yet, and it's in album #{track.container_album.id}" if options[:check_albums] && track.container_album
    {
      "commit"=>"",
      "content"=>{
              track.id=>{"show_donation_button"=>"0",

                          "_artist"=>track.artist,
                          "album_ru"=>"",
                          "relationshiptype_id"=>"-2",
                          "uploaded_data"=>"",
                          "_title"=>track.title,
                          "title_ru"=>"",
                          "album_id"=>container_album.id.to_s,
                          "id"=>track.id,
                          "is_in_startpage"=>"0",
                          "_description"=>"",
                          "is_in_gallery"=>"true",
                          "tag_list"=>"",
                          "genre"=>"",
                          "year"=>track.year,
                          "owner"=>"me",
                          "artist_ru"=>"",
                          "description_ru"=>""
              }.merge(content_params)
      }
    }
  end

  it "add_music action should work for MA items" do
    set_current_user(:ian_curtis)
    track = contents(:jd_newly_added_transmission_track)
    post :add_music, add_music_params(track, contents(:joydivisions_substance_album))
    flash[:error].should == nil
    flash[:success].should_not == nil
  end

  it "track upload should not work for MA if zip is generated already" do
    set_current_user(:matisyahu)
    album = contents(:matisyahu_youth_album)
    album.relationshiptype_id.should_not == nil #albeit strange but pre-requisite for the case
    post :upload,
      {"commit" => "",
       "ownership" => "me",
       "content" => million_track_params,
       "for_album" => album.id}

    flash[:error].should =~ /album.*item/
  end

  it "make_downloadable page should work for albums without titles" do
    album = contents(:joydivisions_closer_album)
    album.update_attribute(:title, nil)
    test_make_downloadable nil
  end

  def test_upload_cover(album)
    post :update, "commit"=>"",
      "content"=>{album.id=>{"relationshiptype_id"=>"-2",
      "_title"=>"",
      "title_ru"=>"",
      "album_id"=>"",
      "is_in_startpage"=>"1",
      "id"=>album.id,
      "is_in_gallery"=>"1",
      "_artist"=>"",
      "year"=>"",
      "genre"=>"",
      "_description"=>"",
      "tag_list"=>"",
      "user_id"=>album.user.id,
      "artist_ru"=>"",
      "description_ru"=>""}},
      "cover_art"=>{"uploaded_data"=>fixture_file_upload("upload/love.png")}

    flash[:error].should == nil
    flash[:success].should_not == nil

    album.reload
    album.cover_art.filename.should =~ /#{album.user.login}_#{album.id}_cover.png/
  end

  it "cover image file should be renamed when uploaded to album with existing cover art" do
    set_current_user(:ian_curtis)
    test_upload_cover(contents(:joydivisions_closer_album))
  end

  it "cover image file should be renamed when uploaded to album without existing cover art" do
    set_current_user(:ian_curtis)
    album = contents(:joydivisions_substance_album)
    album.cover_art.should == nil
    test_upload_cover(album)
  end

  it "board should be deletable" do
    announcement = contents(:chiefs_announcement)
    post :delete, :id => announcement
    response.should be_redirect
    assert_no_errors(assigns(:content))
    flash[:error].should == nil
  end

  it "new music contest page should work" do
    get :music_contest, :user_id => @current_user.id
    response.should be_success
  end

  def post_track_twise
    set_current_user(:ian_curtis)
    track = contents(:jd_newly_added_transmission_track)
    track.albums.count.should == 0
    album = contents(:joydivisions_substance_album)
    post :add_music, add_music_params(track, album, {"is_in_startpage" => "1"})
    post :add_music, add_music_params(track, album, {"is_in_startpage" => "1"}, :check_albums => false)
    track
  end

  it "add_music should not increase featured album items when posted twise" do
    track = post_track_twise
    AlbumItem.count(:conditions => {:content_id => track.id}).should == 2 #one is featured, another is 'substance' album
  end

  it "add_music should not error when posted twise with Bdrb enabled" do
    old = APP_CONFIG[:disable_bdrb]
    APP_CONFIG[:disable_bdrb] = false
    begin
      post_track_twise
    ensure
      APP_CONFIG[:disable_bdrb] = old
    end
    response.should be_redirect
  end

  it "image upload with tool should work" do
    post :upload_with_tool,
      {       :Filename => 'love.png',
              :Filedata => fixture_file_upload("upload/love.png"),
              :album_id => contents(:chiefs_sacred_album).id,
              :user_id => @current_user.id,
              :user_id_sign => 'dcd40a202ee2f07c9157fc455ee4978c',
      }
    response.should be_success
  end

  describe "add_to_inbox__find_user" do

    it "should reject with 'User has no folders available to you for this content type'" do
      set_current_user(:joy_division)
      chief = users(:chief)
      track = contents(:jd_closer_decades_track)
      xhr :post, :add_to_inbox__find_user, :id => track.id, :name => chief.login
      response.should be_success
      response.should have_rjs(:replace_html, 'submit_errors')
      response.should have_rjs(:replace_html, 'submit_inbox_search')
      response.should include_text('User has no folders available to you for this content type')
    end

    it "should reject with 'You do not have an ability to submit content to collection'" do
      set_current_user(:joy_division)
      colletion = users(:collection_with_inbox)
      track = contents(:jd_closer_decades_track)
      xhr :post, :add_to_inbox__find_user, :id => track.id, :name => colletion.login
      response.should be_success
      response.should have_rjs(:replace_html, 'submit_errors')
      response.should have_rjs(:replace_html, 'submit_inbox_search')
      response.should include_text('You do not have an ability to submit content to collection')
    end

    it "should reject with 'Kroogi name not found'" do
      set_current_user(:joy_division)
      track = contents(:jd_closer_decades_track)
      xhr :post, :add_to_inbox__find_user, :id => track.id, :name => "name_not_found"
      response.should be_success
      response.should have_rjs(:replace_html, 'submit_errors')
      response.should have_rjs(:replace_html, 'submit_inbox_search')
      response.should include_text('Kroogi name not found')
    end

    it "should return to user list of avilable inboxes" do
      set_current_user(:joy_division)
      track = contents(:jd_closer_decades_track)
      xhr :post, :add_to_inbox__find_user, :id => track.id, :name => "name_not_found"
      response.should be_success
      response.should render_template('submit/add_to_inbox__find_user.rjs')
      response.should have_rjs(:replace_html, 'submit_errors')
      response.should have_rjs(:replace_html, 'submit_inbox_search')
    end

  end

end
