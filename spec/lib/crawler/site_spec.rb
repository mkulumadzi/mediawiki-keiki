require_relative '../../spec_helper'

describe Crawler::Site do

	describe "default attributes" do

		it "must include httparty methods" do
			Crawler::Site.must_include HTTParty
		end

		it "must have the base url set to the Wikipedia API endpoint" do
			Crawler::Site.base_uri.must_equal 'http://en.wikipedia.org'
		end

	end

	describe "default instance attributes" do

		let(:site) { Crawler::Site.new('Wikipedia')}

		it "must have a query" do
			site.must_respond_to :query
		end

		it "must have the right query" do
			site.query.must_equal 'Wikipedia'
		end

	end

	describe "GET site" do

		let(:site) { Crawler::Site.new('Wikipedia') }

		before do
			VCR.insert_cassette 'site', :record => :new_episodes
		end

		after do
			VCR.eject_cassette
		end

		it "records the fixture" do
			Crawler::Site.get('/w/api.php?continue=&format=json&action=query&titles=Wikipedia&prop=revisions&rvprop=content')
		end

		it "must have a query result method" do
			site.must_respond_to :query_result
		end

		it "must parse the api response from JSON to Hash" do
			site.query_result.must_be_instance_of Hash
		end

		it "must perform the request and get data" do
			site.query_result["batchcomplete"].must_equal ""
		end

		describe "dynamic attributes" do

			before do
				site.query_result
			end

			it "must return the page id if it is present" do
				site.page_id.must_equal 5043734
			end

			it "must return the page hash if it is present" do
				site.page_hash.must_be_instance_of Hash
			end

			it "must return the page title if it is present" do
				site.title.must_equal "Wikipedia"
			end

			it "must return the site content if it is present" do
				site.content.must_be_instance_of String
			end

			it "must raise method missing if attribute is not present" do
				lambda { site.foo_attribute }.must_raise NoMethodError
			end

		end

		describe "caching" do

			# Use Webmock to disable the network connection after fetching the profile
			before do
				site.query_result
				stub_request(:any, /en.wikipedia.org/).to_timeout
			end

			it "must cache the query result" do
				site.query_result.must_be_instance_of Hash
			end

			it "must refresh the profile if forced" do
				lambda { site.query_result(true) }.must_raise Timeout::Error
			end

		end

	end

end

# 	def load_wiki_page(query)
# 		query = query.gsub(' ','%20')
# 		source_url = "http://en.wikipedia.org/w/api.php?format=json&action=query&titles=#{query}&prop=revisions&rvprop=content"
# 		@content = JSON.parse(HTTParty.get(source_url).body)
# 	end

# require 'minitest/spec'
# require 'minitest/autorun'
# require 'rubygems'
# require_relative 'site.rb'

# describe Site do

# 	before do
# 		@test_site = Site.new("Wikipedia")
# 	end

# 	it "has content that is a hash" do
# 		@test_site.content.must_be_instance_of Hash
# 	end

# 	it "has title Wikipedia" do
# 		@test_site.title == "Wikipedia"
# 	end

# 	it "has a summary that is a string" do
# 		@test_site.text_summary.must_be_instance_of String
# 	end

# 	it "has parsed test that is a string" do
# 		@test_site.text_parsed.must_be_instance_of String
# 	end

# 	it "does not have any new lines" do
# 		@test_site.text_summary.index(/\n/).must_be_nil
# 	end

# 	it "does not have any links" do
# 		@test_site.text_summary.index("</ref>").must_be_nil
# 	end

# 	it "does not have a heading" do
# 		@test_site.text_summary.index("({{").must_be_nil
# 	end

# 	it "does not have any trailing curly braces" do
# 		@test_site.text_summary.index("}").must_be_nil
# 	end

# 	it "does not have any files" do
# 		@test_site.text_summary.index(/\[\[File:(.*)\]\]/).must_be_nil	
# 	end

# 	it "does not have any bars" do
# 		@test_site.text_summary.index("|").must_be_nil
# 	end

# 	it "does not have any open square brackets" do
# 		@test_site.text_summary.index("[").must_be_nil
# 	end

# 	it "does not have any closing square brackets" do
# 		assert_nil @test_site.text_summary.index("]").must_be_nil
# 	end

# 	it "does not have any exhobitant quotes" do
# 		@test_site.text_summary.index("'''").must_be_nil
# 	end

# 	it "is not a redirect" do
# 		@test_site.text_summary.index("REDIRECT").must_be_nil
# 	end

# end

