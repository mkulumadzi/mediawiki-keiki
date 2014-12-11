module MediaWiki

	class Query

		attr_accessor :query, :query_result

		include HTTParty

		# Sets the User-Agent header for the HTTP GET request
		headers 'User-Agent' => 'crawler/1.0 (https://github.com/mkulumadzi/crawler)'

		# Sets the base-uri to the Wikimedia API endpoint
		base_uri 'https://en.wikipedia.org'


		def initialize(query)

			# The WikiMedia API requires that requests be limited to 50 sites or less
			raise ArgumentError, "Query exceeds WikiMedia maximum number of sites (50)" unless query.count("|") < 50

			@query = query
			@page_hash = Hash.new

		end

		# Unless force is true, uses existing query_result if it has already been cached
		def query_result(force = false)
			force ? @query_result = get_query_result : @query_result ||= get_query_result
		end

		# Returns a hash filled with Pages 
		def pages

			# Captures the original query and sorts it, for using as keys with the hash
			key_array = @query.split('|').sort
			i = 0

			# Creates a hash, using the original query as the keys and new Site objects as the values
			query_result["query"]["pages"].each do |key, value|
				@page_hash[key_array[i]] = MediaWiki::Page.new(value)
				i += 1
			end

			@page_hash
		end

		private

		# Private method that gets called if the query_result has not been retrieved yet
		def get_query_result
			self.class.get URI.encode("/w/api.php?continue=&format=json&action=query&titles=#{@query}&prop=revisions&rvprop=content&redirects")
		end

	end

end