require_relative '../../spec_helper'

describe Crawler::Site do

	describe "Retrieve a site" do

		let(:site) { Crawler::WikiQuery.new('Wikipedia').pages[:Wikipedia] }

		before do
			VCR.insert_cassette 'site', :record => :new_episodes
		end

		after do
			VCR.eject_cassette
		end

		describe "default attributes" do

			it "must store the site data as a hash" do
				site.site_data.must_be_instance_of Hash
			end

			it "must return the page title" do
				site.title.must_equal "Wikipedia"
			end

			it "must raise method missing it attribute is not present" do
				lambda { site.foo_attribute }.must_raise NoMethodError
			end

		end

		describe "valid site" do

			before do
				site
			end

			it "must return the site content" do
				site.content.must_be_instance_of String
			end

		end

		describe "missing site" do

			let(:site) { Crawler::WikiQuery.new('Foolicious').pages[:Foolicious] }

			it "must be flagged as missing" do
				site.missing.must_equal ""
			end

		end

		# This doesn't work right now...
		# describe "GET invalid site" do

		# 	let(:site) { Crawler::Site.new(:Talk) }

		# 	it "must be flagged as invalid" do
		# 		site.invalid.must_equal ""
		# 	end

		# end

	end

end

