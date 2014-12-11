module Crawler

	class Site

		attr_reader :site_data

		def initialize(hash)
			@site_data = hash
		end

		# Modify method_missing to return results if a matching key can be found within the page hash
		def method_missing(name, *args, &block)
			@site_data.has_key?(name.to_s) ? @site_data[name.to_s] : super
		end

		# Gets the content by looking inside the 'revisions' key in the page hash
		def content
			revisions[0]["*"]
		end

		def to_html
			WikiCloth::Parser.new( :data => content ).to_html
		end

		def to_text
			Nokogiri::HTML(to_html).text
		end

		def summary
			text_array = to_text.split("\n")

			# text = text_array[0]

			# i = 1

			# while text.length <= 140 && i < text_array.length
			# 	text << "\n" + text_array[i]
			# 	i += 1
			# end

			# text

			text_array[0].length <= 140? text_array[0] + "\n" + text_array[1] : text_array[0]
		end

	end

end