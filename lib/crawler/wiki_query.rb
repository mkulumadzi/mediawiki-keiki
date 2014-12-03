module Crawler

	class WikiQuery

		attr_accessor :query, :query_result

		include HTTParty

		base_uri 'http://en.wikipedia.org'

		def initialize(query)
			@query = query
		end

		def query_result(force = false)
			force ? @query_result = get_query_result : @query_result ||= get_query_result
		end

		def pages
			page_hash = Hash.new
			query_result["query"]["pages"].keys.each do |p|
				key = query_result["query"]["pages"][p]["title"].to_sym
				page_hash[key] = Crawler::Site.new(query_result["query"]["pages"][p])
			end
			page_hash
		end

		private

		def get_query_result
			self.class.get URI.encode("/w/api.php?continue=&format=json&action=query&titles=#{@query}&prop=revisions&rvprop=content")
		end

	end

end