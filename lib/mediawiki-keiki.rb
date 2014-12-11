require 'httparty'
require 'wikicloth'
require 'nokogiri'

Dir[File.dirname(__FILE__) + '/mediawiki-keiki/*.rb'].each do |file|
  require file
end