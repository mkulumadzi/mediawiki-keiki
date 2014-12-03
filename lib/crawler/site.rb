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

	end

end