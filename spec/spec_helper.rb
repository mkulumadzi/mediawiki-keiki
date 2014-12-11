#Load the MediaWiki file
require_relative '../lib/mediawiki'

#dependencies
require 'minitest/autorun'
require 'webmock/minitest'
require 'vcr'
require 'pry'
require 'minitest/reporters'

#Minitest reporter 
reporter_options = { color: true}
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]
 
#VCR config
VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/mediawiki_cassettes'
  c.hook_into :webmock
end