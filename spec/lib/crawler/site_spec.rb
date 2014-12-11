require_relative '../../spec_helper'

describe Crawler::Site do

	describe "Retrieve a site" do

		let(:site) { Crawler::WikiQuery.new('foo').pages['foo'] }

		before do
			VCR.insert_cassette 'site', :record => :new_episodes
		end

		after do
			VCR.eject_cassette
		end

		describe "get valid site" do

			it "must get a valid site from WikiQuery pages" do
				site.must_be_instance_of Crawler::Site
			end

			it "must store the site data as a hash" do
				site.site_data.must_be_instance_of Hash
			end

			it "must return the page title" do
				site.title.must_equal "Foobar"
			end

			it "must raise method missing if attribute is not present" do
				lambda { site.foo_attribute }.must_raise NoMethodError
			end

			it "must not point to a redirect" do
				/REDIRECT/.match(site.content).must_equal nil
			end

			it "must return the site content" do
				site.content.must_be_instance_of String
			end

			it "must parse the site content as html" do
				site.to_html.include?('<a href=').must_equal true
			end

			it "must parse the site content to plain text" do
				site.to_text.include?('<a href=').must_equal false
			end

			it "must return a summary of the text" do
				# /#{site.summary}/.match(site.to_text).must_be_instance_of MatchData
				site.summary.must_be_instance_of String
			end

			it "must return at least 140 characters in the short summary" do
				assert_operator(site.summary.length, :>=, 140)
			end

		end

		describe "missing site" do

			let(:site) { Crawler::WikiQuery.new('Foolicious').pages['Foolicious'] }

			it "must be flagged as missing" do
				site.missing.must_equal ""
			end

		end

		describe "get invalid site" do

			let(:site) { Crawler::WikiQuery.new('Talk:').pages['Talk:'] }

			it "must be flagged as invalid" do
				site.invalid.must_equal ""
			end

		end

	end

end

