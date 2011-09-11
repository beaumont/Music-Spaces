require File.dirname(__FILE__) + '/../spec_helper'

describe ProjectAsContent do
  before(:each) do
    CollectionProject.repopulate_all_inclusions
  end

  def check_find_all_ancestor_ids(child, expected_ancestors)
    ancestors = contents(child).find_all_ancestor_ids
    ancestors.to_a.map {|id| User.find(id).login}.sort.should == expected_ancestors.sort
  end

  it "find_all_ancestor_ids should work: abce + ade case" do
    check_find_all_ancestor_ids :bill_laswell_as_ambientdub_content,
                                ['kroogi-music', 'dub', 'ambient-dub', 'ambient']
  end

  it "find_all_ancestor_ids should work: ad + abcd case" do
    check_find_all_ancestor_ids :joydivision_as_postpunk_content, ['kroogi-music', 'rock', 'post-punk']
  end

  it "repopulate_collection_inclusions should work - distance 1" do
    joydivision_as_postpunk_content = contents(:joydivision_as_postpunk_content)
    joydivision_as_postpunk_content.repopulate_collection_inclusions
    ci = users('post-punk').inclusions.to_a.find {|ci| ci.child_pac_id == joydivision_as_postpunk_content.id}
    ci.should_not == nil
    ci.should be_direct
  end

  it "repopulate_collection_inclusions should work - distance 3" do
    bill_laswell_as_ambientdub_content = contents(:bill_laswell_as_ambientdub_content)
    bill_laswell_as_ambientdub_content.repopulate_collection_inclusions
    ci = users('kroogi-music').inclusions.to_a.find {|ci| ci.child_pac_id == bill_laswell_as_ambientdub_content.id}
    ci.should_not == nil
    ci.should_not be_direct
  end

  it "repopulate_collection_inclusions shouldn't produce dupes" do
    contents(:joydivision_as_postpunk_content).repopulate_collection_inclusions
    joydivision_as_kroogimusic_content = contents(:joydivision_as_kroogimusic_content)
    joydivision_as_kroogimusic_content.repopulate_collection_inclusions

    cis = users('kroogi-music').inclusions.select {|ci| ci.child_pac.body_project == users(:joy_division)}
    cis.size.should == 1 #there should not be 2 inclusions of JD in KM
    cis[0].should be_direct #direct child should have preference
  end


  def add_jd_to_ambient_dub(get_jd_inclusions_in_dir)
    joy_division = users(:joy_division)
    ActiveRecord::Base.without_monitoring do
      ProjectAsContent.create!(:body_project_name => joy_division.login, :user_id => users('ambient-dub').id, :cat_id => Content::CATEGORIES[:project][:id])
    end

    cis = users(get_jd_inclusions_in_dir).inclusions.select { |ci| ci.child_pac.body_project == joy_division }
    return cis
  end
  
  it "new PAC should populate CollectionInclusions - distance 2" do
    cis = add_jd_to_ambient_dub('dub')
    cis.should_not be_empty
  end

  it "new PAC shouldn't introduce CollectionInclusions dupes" do
    cis = add_jd_to_ambient_dub('kroogi-music')
    cis.size.should == 1 #there should not be 2 inclusions of JD in KM
  end

  it "PAC deletion should remove relevant collection inclusions" do
    contents(:bill_laswell_as_ambientdub_content).destroy
    cis = users('kroogi-music').inclusions.select {|ci| ci.child_pac.body_project == users(:bill_laswell)}
    cis.size.should == 0
  end

  it "user deletion should remove relevant collection inclusions" do
    users(:bill_laswell).destroy
    cis = users('kroogi-music').inclusions.select {|ci| ci.child_pac.body_project == users(:bill_laswell)}
    cis.size.should == 0
  end

  it "PAC deletion should not remove some inclusions" do
    contents(:joydivision_as_postpunk_content).destroy
    cis = users('kroogi-music').inclusions.select {|ci| ci.child_pac.body_project == users(:joy_division)}
    cis.size.should == 1
  end

  it "PAC deletion should introduce other inclusions sometimes" do
    contents(:joydivision_as_kroogimusic_content).destroy
    cis = users('kroogi-music').inclusions.select {|ci| ci.child_pac.body_project == users(:joy_division)}
    cis.size.should == 1
    cis[0].child_pac.should == contents(:joydivision_as_postpunk_content)
  end

  it "PAC deletion should remove whole branches for collection removals - subprojects case" do
    contents(:postpunk_as_rock_content).destroy

    users('kroogi-music').inclusions.select {|ci| ci.child_pac.body_project == users('post-punk')}.should be_empty
    users('kroogi-music').inclusions.select {|ci| ci.child_pac.body_project == users(:birthday_party)}.should be_empty
  end

  it "PAC deletion should remove whole branches for collection removals - subcollections case" do
    contents(:rock_as_kroogimusic_content).destroy

    users('kroogi-music').inclusions.select {|ci| ci.child_pac.body_project == users(:rock)}.should be_empty
    users('kroogi-music').inclusions.select {|ci| ci.child_pac.body_project == users('post-punk')}.should be_empty
    users('kroogi-music').inclusions.select {|ci| ci.child_pac.body_project == users(:birthday_party)}.should be_empty
  end
  
  it "PAC deletion should leave inclusions from other pathes for collection removals" do
    contents(:rock_as_kroogimusic_content).destroy

    cis = users('kroogi-music').inclusions.select {|ci| ci.child_pac.body_project == users(:joy_division)}
    cis.size.should == 1
    cis[0].child_pac.should == contents(:joydivision_as_kroogimusic_content)
  end

  it "PAC deletion should keep branches consistent for collection removals" do
    contents(:rock_as_kroogimusic_content).destroy

    users('rock').inclusions.select {|ci| ci.child_pac.body_project == users(:birthday_party)}.size.should == 1
    users('rock').inclusions.select {|ci| ci.child_pac.body_project == users('post-punk')}.size.should == 1
    users('rock').inclusions.select {|ci| ci.child_pac.body_project == users(:joy_division)}.size.should == 1
  end

  it "PAC addition of branch adds inclusions of its children - subcollections case" do
    contents(:rock_as_kroogimusic_content).destroy

    rock = users(:rock)
    ActiveRecord::Base.without_monitoring do
      ProjectAsContent.create!(:body_project_name => rock.login, :user_id => users('kroogi-music').id, :cat_id => Content::CATEGORIES[:project][:id])
    end

    users('kroogi-music').inclusions.select {|ci| ci.child_pac.body_project == users(:rock)}.size.should == 1
    users('kroogi-music').inclusions.select {|ci| ci.child_pac.body_project == users('post-punk')}.size.should == 1
    users('kroogi-music').inclusions.select {|ci| ci.child_pac.body_project == users(:birthday_party)}.size.should == 1
  end

  it "stop list should work on direct parent" do
    users('rock').inclusions.select {|ci| ci.child_pac.body_project == users(:sigur_ros)}[0].should be_stopped
  end

  it "stop list should not work on indirect parent" do
    users('kroogi-music').inclusions.select {|ci| ci.child_pac.body_project == users(:sigur_ros)}[0].should_not be_stopped
  end

end
