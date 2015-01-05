require_relative '../../spec_helper'

describe MediaWiki::Page do

	describe "Retrieve a page" do

		let(:page) { MediaWiki::Query.new('foo').pages['foo'] }

		before do
			VCR.insert_cassette 'page', :record => :new_episodes
		end

		after do
			VCR.eject_cassette
		end

		describe "get valid page" do

			it "must get a valid page from WikiQuery pages" do
				page.must_be_instance_of MediaWiki::Page
			end

			it "must store the page data as a hash" do
				page.page_data.must_be_instance_of Hash
			end

			it "must return the page title" do
				page.title.must_equal "Foobar"
			end

			it "must raise method missing if attribute is not present" do
				lambda { page.foo_attribute }.must_raise NoMethodError
			end

			it "must not point to a redirect" do
				/REDIRECT/.match(page.content).must_equal nil
			end

			it "must return the page content" do
				page.content.must_be_instance_of String
			end

			it "must parse the page content as html" do
				page.to_html.include?('<a href=').must_equal true
			end

			it "must remove extra line breaks" do
				page.remove_extra_carriage_returns("Foo\n\n\nText").must_equal "Foo\nText"
			end

			it "must parse the page content to plain text" do
				page.to_text.include?('<a href=').must_equal false
			end

			it "must return a summary of the text" do
				page.summary.must_be_instance_of String
			end

			it "must return at least 140 characters in the short summary" do
				assert_operator(page.summary.length, :>=, 140)
			end

		end

		describe "missing page" do

			let(:page) { MediaWiki::Query.new('Foolicious').pages['Foolicious'] }

			it "must be flagged as missing" do
				page.missing.must_equal ""
			end

		end

		describe "get invalid page" do

			let(:page) { MediaWiki::Query.new('Talk:').pages['Talk:'] }

			it "must be flagged as invalid" do
				page.invalid.must_equal ""
			end

		end

	end

end

