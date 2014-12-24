Gem::Specification.new do |s|

	# Specifications
	s.name					= 'mediawiki-keiki'
	s.version				= '1.0.2'
	s.date					= '2014-12-24'
	s.required_ruby_version	= '~> 2.0'
	s.summary				= 'MediaWiki Keiki'
	s.description			= 'A client for the MediaWiki API'
	s.authors				= ["Evan Waters"]
	s.email					= ["evan.waters@gmail.com"]
	s.files					= ["Rakefile", "LICENSE", "README.md", "Gemfile", "lib/mediawiki-keiki.rb", "lib/mediawiki-keiki/page.rb", "lib/mediawiki-keiki/query.rb", "spec/spec_helper.rb", "spec/lib/mediawiki-keiki/page_spec.rb", "spec/lib/mediawiki-keiki/query_spec.rb"]
	s.homepage				= 'https://github.com/mkulumadzi/mediawiki-keiki'
	s.license				= 'MIT'
	s.extra_rdoc_files 		= ["README.md"]

	# Dependencies
	s.add_runtime_dependency 'httparty', '~> 0.13', '>= 0.13.3'
	s.add_runtime_dependency 'wikicloth', '~> 0.8', '>= 0.8.1'
	s.add_runtime_dependency 'nokogiri', '~> 1.6', '>= 1.6.5'
	s.add_runtime_dependency 'webmock', '~> 1.20', '>= 1.20.4'
	s.add_runtime_dependency 'vcr', '~> 2.9', '>= 2.9.3'
	s.add_runtime_dependency 'turn', '~> 0.9', '>= 0.9.7'
	s.add_runtime_dependency 'rake', '~> 10.4', '>= 10.4.2'
	s.add_runtime_dependency 'pry', '~> 0.10', '>= 0.10.1'
	s.add_runtime_dependency 'minitest-reporters', '~> 0.14', '>= 0.14.24'

end