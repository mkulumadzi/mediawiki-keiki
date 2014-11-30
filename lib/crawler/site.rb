require 'rubygems'
require 'httparty'
require 'marker'

class Site
	attr_accessor :content, :pages, :page_id, :title, :summary, :text_summary, :text_parsed

	def initialize(query)

		load_wiki_page(query)

		parse_wiki_page

		if @redirect
			self.setup(@redirect)
		end

	end

	def load_wiki_page(query)
		query = query.gsub(' ','%20')
		source_url = "http://en.wikipedia.org/w/api.php?format=json&action=query&titles=#{query}&prop=revisions&rvprop=content"
		@content = JSON.parse(HTTParty.get(source_url).body)
	end

	def parse_wiki_page
		extract_page_id
		get_title
		get_summary
		find_redirect
		use_marker_to_parse_text
	end

	def extract_page_id
		@pages = @content["query"]["pages"]
		@page_id = @pages.keys[0]
	end	

	def get_title
		@title = @pages[@page_id]["title"]
	end

	def get_summary
		@summary = @pages[page_id]["revisions"][0]["*"].split("==")[0]
		@text_summary = remove_wiki_markup(@summary)
	end

	def remove_wiki_markup(text)
		text = text.gsub(/\n/,'')
		text = text.gsub(/<ref>(.*?)<\/ref>/,'')
		text = text.gsub(/<ref name=(.*?)\/>/,'')
		text = text.gsub(/<ref(.*?)\/>/,'')
		text = text.gsub(/\(\{\{(.*?)\}\}\)/,'')
		text = text.gsub(/\{\{(.*?)\}\}/,'')
		text = text.gsub(/\[\[File(.*?)\]\]/, '')
		text = text.gsub(/\[\[(.*)\|/, '[[')
		text = text.gsub('[','')
		text = text.gsub(']','')
		text = text.gsub("'''",'')
	end

	def find_redirect
		@redirect = redirect_to(@text_summary)
	end

	def use_marker_to_parse_text
		@text_parsed = (Marker.parse @summary).to_s
	end

	def redirect_to(text)
		if text && text.index("REDIRECT")
			text.gsub("#REDIRECT ", "")
		end
	end

end