require 'rubygems'
require 'sinatra'
require 'httparty'
require 'awesome_print'
require 'feedzirra'


get '/' do
  entries = []

  feed = Feedzirra::Feed.fetch_and_parse("http://www.insidehighered.com/blogs/feed/Technology%20and%20Learning")
  feed.entries.each do |entry|
    response = HTTParty.get(entry.url)
    n = Nokogiri::HTML(response.body)
    content = n.css('.pane-node-body .field-name-body .field-item.even').to_s
     entries << {
      title: entry.title.encode(:xml => :text),
      link: entry.url,
      updated: entry.published,
      summary: entry.summary.encode(:xml => :text),
      id: entry.id,
      content: content.encode(:xml => :text)
     }
  end

  erb :feed, :locals => {entries: entries, title: feed.title, url: feed.url, updated: feed.last_modified}
end