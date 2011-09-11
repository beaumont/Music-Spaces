require File.dirname(__FILE__) + '/../spec_helper'
require 'translation_tasks_mixin'

describe 'Translations' do
  it "tag injection should work for .t" do
    "one two {{start_tag}}huh{{end_tag}}".t.should == "one two <tag>huh</tag>"
  end

  it "tag injection should work for / {}" do
    ("one {{x}} {{start_tag}}huh{{end_tag}}" / {:x => 'two'}).should == "one two <tag>huh</tag>"
  end

  it "tag injection should work for / scalar" do
    ("one %s {{start_tag}}huh{{end_tag}}" / 'two').should == "one two <tag>huh</tag>"
  end

  it "tag injection should work for / []" do
    ("one %s {{start_tag}}huh{{end_tag}}" / ['two']).should == "one two <tag>huh</tag>"
  end

  include TranslationTasksMixin
  it "source strings should have no mixed case issues" do
    @report = ""
    strings = scan_strings
    strings_by_case = self.strings_by_case(strings)
    @report = ""
    build_mixed_cases_report(strings_by_case)
    @report.gsub!("\n", "")
    @report.gsub!("\t", " ")
    5.times {@report.gsub!('  ', " ")}
    @report.gsub!('"', "'")
    @report.should == ""
  end
end