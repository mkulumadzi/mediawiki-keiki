module Crawler

	class WikiQuery

		attr_accessor :query, :query_result

		include HTTParty

		base_uri 'https://en.wikipedia.org'

		def initialize(query)
			@query = query
			@page_hash = Hash.new
		end

		def query_result(force = false)
			force ? @query_result = get_query_result : @query_result ||= get_query_result
		end

		def pages
			key_array = @query.split('|').sort
			i = 0

			query_result["query"]["pages"].each do |key, value|
				@page_hash[key_array[i]] = Crawler::Site.new(value)
				i += 1
			end

			@page_hash
		end

		private

		def get_query_result
			self.class.get URI.encode("/w/api.php?continue=&format=json&action=query&titles=#{@query}&prop=revisions&rvprop=content&redirects")
		end

	end

end