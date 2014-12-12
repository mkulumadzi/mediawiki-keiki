# MediaWiki-Keiki

A Ruby API client for the [MediaWiki API](http://www.mediawiki.org/wiki/API:Main_page)

## Features

Query the WikiMedia API, returning JSON documents
- Multiple pages per query supported

Retrieve data from WikiMedia pages, including
- Title
- Full text
- Full text as HTML
- Short text summary


## Installation

Install as a ruby gem

```shell
$ gem install mediawiki-keiki
```

Or add it to your application's `Gemfile`:

```ruby
gem 'mediawiki-gateway'
```


## Usage

Create a simple query with a single page

```ruby
query = WikiMedia::Query.new('foo')
```

Create a query with multiple pages

```ruby
query = WikiMedia::Query.new('foo|bar')
```

Retrieve a page from a query

```ruby
foo_page = query.pages['foo']
```

Get the summary of a page

```ruby
puts foo_page.summary
```