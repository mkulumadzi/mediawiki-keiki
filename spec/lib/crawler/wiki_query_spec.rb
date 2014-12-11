require_relative '../../spec_helper'

describe Crawler::WikiQuery do

	describe "default attributes" do

		it "must include httparty methods" do
			Crawler::WikiQuery.must_include HTTParty
		end

		it "must have the base url set to the Wikipedia API endpoint" do
			Crawler::WikiQuery.base_uri.must_equal 'https://en.wikipedia.org'
		end

	end

	describe "default instance attributes" do

		let(:wiki_query) { Crawler::WikiQuery.new('foo')}

		it "must have a query" do
			wiki_query.must_respond_to :query
		end

		it "must have the right query" do
			wiki_query.query.must_equal 'foo'
		end

	end

	describe "GET site" do

		let(:wiki_query) { Crawler::WikiQuery.new('foo') }

		before do
			VCR.insert_cassette 'wiki_query', :record => :new_episodes
		end

		after do
			VCR.eject_cassette
		end

		it "records the fixture" do
			Crawler::WikiQuery.get('/w/api.php?continue=&format=json&action=query&titles=foo&prop=revisions&rvprop=content&redirects')
		end

		it "must have a query result method" do
			wiki_query.must_respond_to :query_result
		end

		it "must parse the api response from JSON to Hash" do
			wiki_query.query_result.must_be_instance_of Hash
		end

		it "must perform the request and get data" do
			wiki_query.query_result["batchcomplete"].must_equal ""
		end

		describe "dynamic attributes" do

			before do
				wiki_query.query_result
			end

			it "must return the pages as a hash" do
				wiki_query.pages.must_be_instance_of Hash
			end

			it "must use keys in pages that match the original search terms" do
				wiki_query.pages.keys[0].must_equal 'foo'
			end

			it "must store the pages as Site classes" do
				wiki_query.pages['foo'].must_be_instance_of Crawler::Site
			end

		end

		describe "caching" do

			# Use Webmock to disable the network connection after fetching the profile
			before do
				wiki_query.query_result
				stub_request(:any, /en.wikipedia.org/).to_timeout
			end

			it "must cache the query result" do
				wiki_query.query_result.must_be_instance_of Hash
			end

			it "must refresh the profile if forced" do
				lambda { wiki_query.query_result(true) }.must_raise Timeout::Error
			end

		end

		describe "multiple sites" do

			let(:wiki_query) { Crawler::WikiQuery.new('foo|bar|camp') }

			it "must return all of the sites" do
				wiki_query.pages.length.must_equal 3
			end

			it "must tag the sites with the right query terms" do
				wiki_query.pages['foo'].title.must_equal 'Foobar'
				wiki_query.pages['bar'].title.must_equal 'Bar'
				wiki_query.pages['camp'].title.must_equal 'Camp'
			end

		end

	end

end