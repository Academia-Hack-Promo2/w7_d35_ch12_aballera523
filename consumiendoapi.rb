#!/usr/bin/ruby
# -*- coding: utf-8 -*-
require 'httparty'

class Mashable
	include HTTParty
	base_uri 'http://mashable.com/stories.json'

	def notices
		response = HTTParty.get('http://mashable.com/stories.json')
		response["new"].each do |notice|
			puts notice['author']
			puts notice['title']
			puts notice['post_date']
			puts notice['link']
			puts "-"*64
		end
	end
end

class Digg
	include HTTParty
	base_uri 'http://digg.com/api/news/popular.json'

	def notices
		response = HTTParty.get('http://digg.com/api/news/popular.json')
		response["data"]["feed"].each do |notice|
			puts notice["content"]['author']
			puts notice["content"]['title']
			puts notice["content"]['date_published']
			puts notice["content"]['url']
			puts "-"*64
		end
	end
end

class Reddit
	include HTTParty
	base_uri 'http://www.reddit.com/.json'

	def notices
		response = HTTParty.get('http://www.reddit.com/.json')
		response["data"]["children"].each do |notice|
			puts notice["data"]['author']
			puts notice["data"]['title']
			puts notice["data"]['created']
			puts notice["data"]['url']
			puts "-"*64
		end
	end
end

def main
	puts "*"*64
	puts 'Mashable'
	puts "*"*64
	news_mashable = Mashable.new
	news_mashable.notices
	puts "*"*64
	puts 'Digg'
	puts "*"*64
	news_digg = Digg.new
	news_digg.notices
	puts "*"*64
	puts 'Reddit'
	puts "*"*64
	news_reddit = Reddit.new
	news_reddit.notices
end
main
