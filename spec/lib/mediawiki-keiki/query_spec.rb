require_relative '../../spec_helper'

describe MediaWiki::Query do

	describe "default attributes" do

		it "must include httparty methods" do
			MediaWiki::Query.must_include HTTParty
		end

		it "must have the base url set to the Wikipedia API endpoint" do
			MediaWiki::Query.base_uri.must_equal 'https://en.wikipedia.org'
		end

		it "must have the User-Agent header" do
			MediaWiki::Query.headers["User-Agent"].must_equal "crawler/1.0 (https://github.com/mkulumadzi/crawler)"
		end

	end

	describe "default instance attributes" do

		let(:wiki_query) { MediaWiki::Query.new('foo')}

		it "must have a query" do
			wiki_query.must_respond_to :query
		end

		it "must have the right query" do
			wiki_query.query.must_equal 'foo'
		end

	end

	describe "GET site" do

		let(:wiki_query) { MediaWiki::Query.new('foo') }

		before do
			VCR.insert_cassette 'wiki_query', :record => :new_episodes
		end

		after do
			VCR.eject_cassette
		end

		it "records the fixture" do
			MediaWiki::Query.get('/w/api.php?continue=&format=json&action=query&titles=foo&prop=revisions&rvprop=content&redirects')
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
				# wiki_query.query_result
				@initialized_result_map = [{:search_term => "foo"}]
				@normalized_hash_array = [{"from"=>"foo", "to" =>"Foo"}]
				@redirected_hash_array = [{"from" => "Foo", "to" => "Foobar"}]
				@normalized_map = [{:search_term => "foo", :normalized => "Foo"}]
				@redirected_map = [{:search_term => "foo", :normalized => "Foo", :redirected => "Foobar"}]
			end

			it "must initalize a result map with the search terms in the keys and values" do
				wiki_query.initialize_map.must_equal @initialized_result_map
			end

			it "must get an array of a hash with normalizations" do
				wiki_query.get_query_map("normalized").must_equal @normalized_hash_array
			end

			it "must get an array of a hash with redirects" do
				wiki_query.get_query_map("redirects").must_equal @redirected_hash_array
			end

			it "must get normalizations for the original search terms" do
				wiki_query.get_normalizations_for(@initialized_result_map, @normalized_hash_array).must_equal @normalized_map
			end

			it "must get redirects for the original or normalized search terms" do
				wiki_query.get_redirects_for(@normalized_map, @redirected_hash_array).must_equal @redirected_map
			end

			# it "must apply the noramalization map to the results map" do
			# 	wiki_query.map_from_to({"foo"=>"foo"}, @normalized_hash_array).must_equal @normalized_map
			# end

			# it "must apply the redirects map to the normalized result map" do
			# 	wiki_query.map_from_to(@normalized_map,@redirected_hash_array).must_equal @redirected_map
			# end

			it "must map the original query to the normalized, redirected title" do
				wiki_query.map_query_to_results.must_equal @redirected_map
			end

			describe "find result map match for title" do

				before do
					@result_map = wiki_query.map_query_to_results
					@page_title = "Foobar"
				end

				it "must return the final title" do
					wiki_query.get_final_title(@result_map[0]).must_equal "Foobar"
				end

				it "must return the original query that matches the page title" do
					wiki_query.find_result_map_match_for_title(@result_map, @page_title).must_equal 'foo'
				end

			end

			it "must return the pages as a hash" do
				wiki_query.pages.must_be_instance_of Hash
			end

			it "must store the pages as Page classes" do
				wiki_query.pages['foo'].must_be_instance_of MediaWiki::Page
			end

		end

		describe "a page with no normalization or redirects" do

			let(:wiki_query) { MediaWiki::Query.new('Main Page')}

			before do
				@final_result_map = [{:search_term => "Main Page"}]
			end

			it "should return nil for the normalization map" do
				wiki_query.get_query_map("normalized").must_equal nil
			end

			it "should return nil for the redirects map" do
				wiki_query.get_query_map("redirects").must_equal nil
			end

			it "should return a result map pointing to the original search term" do
				wiki_query.map_query_to_results.must_equal @final_result_map
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

		describe "multiple pages" do

			let(:wiki_query) { MediaWiki::Query.new('Partners In Health|ThoughtWorks|Accion International') }

			it "must get a result map for each page" do
				wiki_query.map_query_to_results.length.must_equal 3
			end

			it "must return all of the sites" do
				wiki_query.pages.length.must_equal 3
			end

			it "must tag the first page with the right query term" do
				wiki_query.pages['Partners In Health'].title.must_equal 'Partners In Health'
			end

			it "must tag the second page with the right query term" do
				wiki_query.pages['ThoughtWorks'].title.must_equal 'ThoughtWorks'
			end

			it "must tag the last page with the right query term" do
				wiki_query.pages['Accion International'].title.must_equal 'ACCION International'
			end

		end

		describe "give warning if WikiMedia API limit of 50 sites exceeded" do

			search_string = ""

			("1".."51").each { |x| search_string << x + "|"}

			search_string = search_string.chomp("|")

			it "must throw an error if search string has more than 50 sites" do
				assert_raises ArgumentError do
					MediaWiki::Query.new("#{search_string}".to_s)
				end
			end

		end

	end

end