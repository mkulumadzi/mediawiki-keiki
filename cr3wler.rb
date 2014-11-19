require 'rubygems'
require_relative 'site.rb'

input = ARGV[0]
output = ARGV[1]

sources = File.open(input, "r").read.split(',')
sources.each { |item| item.gsub!("'",'')}

result = File.new(output, "w")

def search_wiki(sources)
	sites = []
	sources.each { |item| sites << Site.new(item)}
	sites
end

orgs = search_wiki(sources)

orgs.each { |org| result << org.title + "\t" + org.chopped.to_s + "\n"}

result.close