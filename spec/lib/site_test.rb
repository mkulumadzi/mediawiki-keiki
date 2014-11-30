require 'minitest/spec'
require 'minitest/autorun'
require 'rubygems'
require_relative 'site.rb'

describe Site do

	before do
		@test_site = Site.new("Wikipedia")
	end

	it "has content that is a hash" do
		@test_site.content.must_be_instance_of Hash
	end

	it "has title Wikipedia" do
		@test_site.title == "Wikipedia"
	end

	it "has a summary that is a string" do
		@test_site.text_summary.must_be_instance_of String
	end

	it "has parsed test that is a string" do
		@test_site.text_parsed.must_be_instance_of String
	end

	it "does not have any new lines" do
		@test_site.text_summary.index(/\n/).must_be_nil
	end

	it "does not have any links" do
		@test_site.text_summary.index("</ref>").must_be_nil
	end

	it "does not have a heading" do
		@test_site.text_summary.index("({{").must_be_nil
	end

	it "does not have any trailing curly braces" do
		@test_site.text_summary.index("}").must_be_nil
	end

	it "does not have any files" do
		@test_site.text_summary.index(/\[\[File:(.*)\]\]/).must_be_nil	
	end

	it "does not have any bars" do
		@test_site.text_summary.index("|").must_be_nil
	end

	it "does not have any open square brackets" do
		@test_site.text_summary.index("[").must_be_nil
	end

	it "does not have any closing square brackets" do
		assert_nil @test_site.text_summary.index("]").must_be_nil
	end

	it "does not have any exhobitant quotes" do
		@test_site.text_summary.index("'''").must_be_nil
	end

	it "is not a redirect" do
		@test_site.text_summary.index("REDIRECT").must_be_nil
	end

end

