require 'test/unit'
require 'rubygems'
require_relative 'site.rb'

class SiteTest < Test::Unit::TestCase

	def setup
		@test_site = Site.new("Wikipedia")
	end

	def test_that_content_is_a_hash
		assert_equal @test_site.content.class, Hash, "Site content is a hash"
	end

	def test_that_text_summary_is_a_string
		assert_equal @test_site.text_summary.class, String, "Site summary is a string"
	end

	def test_that_summary_has_no_markdown_text
		assert_nil @test_site.text_summary.index(/\n/)
		assert_nil @test_site.text_summary.index("</ref>")
		assert_nil @test_site.text_summary.index("({{")
		assert_nil @test_site.text_summary.index("}")
		assert_nil @test_site.text_summary.index(/\[\[File:(.*)\]\]/)
		assert_nil @test_site.text_summary.index("|")
		assert_nil @test_site.text_summary.index("[")
		assert_nil @test_site.text_summary.index("]")
		assert_nil @test_site.text_summary.index("'''")

	end

end