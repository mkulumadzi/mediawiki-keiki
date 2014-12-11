require 'httparty'
require 'wikicloth'
require 'nokogiri'

Dir[File.dirname(__FILE__) + '/crawler/*.rb'].each do |file|
  require file
end

# require_relative 'site.rb'

# class Cr3wler

# 	attr_accessor :sources, :sites, :result

# 	def initialize(input_file, output_file)
# 		load_search_strings(input_file)
# 		load_sites
# 		output_results_into_file(output_file)
# 	end

# 	def load_search_strings(input_file)
# 		@sources = File.open(input_file, "r").read.split(',')
# 		@sources.each { |item| item.gsub!("'",'')}
# 	end

# 	def load_sites
# 		@sites = []
# 		@sources.each { |item| @sites << Site.new(item)}
# 	end

# 	def output_results_into_file(output_file)
# 		@result = File.new(output_file, "w")
# 		@sites.each { |site| @result << site.title + "\t" + site.summary + "\n"}
# 		@result.close
# 	end

# end

# new_search = Cr3wler.new(ARGV[0], ARGV[1])