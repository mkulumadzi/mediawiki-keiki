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

			result_map = map_query_to_results

			query_result["query"]["pages"].each do |key, value|

				page_title = value["title"]
				original_query = find_result_map_match_for_title(result_map, page_title)
				@page_hash[original_query] = MediaWiki::Page.new(value)

			end

			@page_hash
		end

		def find_result_map_match_for_title(result_map, page_title)
			result_map.each do |h|
				final_title = get_final_title(h)
				if page_title == final_title
					return h[:search_term]
				end
			end
			nil
		end

		def get_final_title(result_map_hash)
			if result_map_hash[:redirected]
				final_title = result_map_hash[:redirected]
			elsif result_map_hash[:normalized]
				final_title = result_map_hash[:normalized]
			else
				final_title = result_map_hash[:search_term]
			end
			final_title
		end
				

		# Maps original query to results
		def map_query_to_results

			#Initalize map
			result_map = initialize_map

			# Apply the normalization to the result map
			normalized = get_query_map("normalized")
			if normalized
				result_map = get_normalizations_for(result_map, normalized)
			end

			# Apply the redirects to the result map
			redirects = get_query_map("redirects")
			if redirects
				result_map = get_redirects_for(result_map, redirects)
			end

			result_map

		end

		# Initially create an array of hashses with the original :search_terms
		def initialize_map
			result_map = []
			original_terms = @query.split('|')

			original_terms.each { |k| result_map << {:search_term => k } }
			result_map
		end

		# Add :normalized key to the result map if the original search term was normalized
		def get_normalizations_for(result_map, normalized)
				result_map.each do |rm|
					normalized.each do |n|
						rm[:normalized] = n["to"] if n["from"] == rm[:search_term]
					end
				end
			result_map
		end

		# Add :redirected key to the result map if the either the original search term or the normalized term were redirected
		def get_redirects_for(result_map, redirects)
			result_map.each do |rm|
				redirects.each do |r|
					rm[:redirected] = r["to"] if r["from"] == rm[:search_term] ||  r["from"] == rm[:normalized]
				end
			end
			result_map
		end

		# Get maps (normalization and redirect) from the wiki query result
		def get_query_map(map_type)
			query_result["query"][map_type] # if query_result["query"][map_type]
		end

		private

		# Private method that gets called if the query_result has not been retrieved yet; gets query and parses as a hash.
		def get_query_result
			self.class.get URI.encode("/w/api.php?continue=&format=json&action=query&titles=#{@query}&prop=revisions&rvprop=content&redirects")
		end

	end

end