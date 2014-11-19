require 'rubygems'
require 'httparty'

class Site
	attr_accessor :content, :page_id, :title, :summary, :text_summary

	def initialize(query)

		self.setup(query)

		if @redirect
			self.setup(@redirect)
		end

	end

	def setup(query)
		query = query.gsub(' ','%20')

		source_url = "http://en.wikipedia.org/w/api.php?format=json&action=query&titles=#{query}&prop=revisions&rvprop=content"

		@content = JSON.parse(HTTParty.get(source_url).body)
		@pages = @content["query"]["pages"]
		@page_id = @pages.keys[0]
		@title = @pages[@page_id]["title"]
		@summary = @pages[page_id]["revisions"][0]["*"].split("==")[0]
		@text_summary = self.unmark_wiki(@summary)
		@redirect = self.redirect_to(@text_summary)

	end

	def unmark_wiki(text)

		to_chomp = [
			/\n/,
			/<ref>(.*?)<\/ref>/
		]

		chomped = to_chomp.map {
			
		}

		text = text.gsub(/\n/,'')
		text = text.gsub(/<ref>(.*?)<\/ref>/,'')
		# text = text.gsub(/<ref name=(.*?)\/>/,'')
		# text = text.gsub(/<ref(.*?)\/>/,'')
		# text = text.gsub(/\(\{\{(.*?)\}\}\)/,'')
		# text = text.gsub(/\{\{(.*?)\}\}/,'')
		# text = text.gsub(/\[\[File(.*?)\]\]/, '')
		# text = text.gsub(/\[\[(.*)\|/, '[[')
		# text = text.gsub('[','')
		# text = text.gsub(']','')
		# text = text.gsub("'''",'')

	end

	def redirect_to(text)
		if text && text.index("REDIRECT")
			text.gsub("#REDIRECT ", "")
		end
	end

	def find_matches(text)

	end

end