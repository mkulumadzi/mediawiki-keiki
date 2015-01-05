module MediaWiki

	class Page

		attr_reader :page_data

		def initialize(hash)
			@page_data = hash
		end

		# Modify method_missing to return results if a matching key can be found within the page hash
		def method_missing(name, *args, &block)
			@page_data.has_key?(name.to_s) ? @page_data[name.to_s] : super
		end

		# Gets the content by looking inside the 'revisions' key in the page hash
		def content
			revisions[0]["*"]
		end

		# Uses the WikiCloth gem to convert the content from WikiMarkup to HTML
		def to_html
			WikiCloth::Parser.new( :data => content ).to_html
		end

		# Converts the content to plain text
		def to_text
			remove_extra_carriage_returns(Nokogiri::HTML(to_html).text)
		end

		def remove_extra_carriage_returns(text)
			text.gsub(/\n{2,}/,"\n")
		end

		# Returns a short summary that is at least 140 characters long
		def summary
			text_array = to_text.split("\n")
			text = text_array[0]
			i = 1

			while text.length <= 140 && i < text_array.length
				text << "\n" + text_array[i]
				i += 1
			end

			text

		end

	end

end