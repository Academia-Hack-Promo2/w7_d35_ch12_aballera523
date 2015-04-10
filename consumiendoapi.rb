#!/usr/bin/ruby
# -*- coding: utf-8 -*-
require 'httparty'

class Mashable
	include HTTParty
	base_uri 'http://mashable.com/stories.json'

	def notices
		feed_mashable = Array.new
		response = HTTParty.get('http://mashable.com/stories.json')
		response["new"].each do |notice|
			author = notice['author']
			title = notice['title']
			date = notice['post_date']
			url = notice['link']
			website = 'Mashable'
			notice = Notice.new(author, title, date, url, website)
			feed_mashable.push(notice)
		end
		return feed_mashable
	end
end

class Digg
	include HTTParty
	base_uri 'http://digg.com/api/news/popular.json'

	def notices
		feed_digg = Array.new
		response = HTTParty.get('http://digg.com/api/news/popular.json')
		response["data"]["feed"].each do |notice|
			author = notice["content"]['author']
			title = notice["content"]['title']
			date = notice["content"]['date_published']
			url = notice["content"]['url']
			website = 'Digg'
			notice = Notice.new(author, title, date, url, website)
			feed_digg.push(notice)
		end
		return feed_digg
	end
end

class Reddit
	include HTTParty
	base_uri 'http://www.reddit.com/.json'

	def notices
		feed_reddit = Array.new
		response = HTTParty.get('http://www.reddit.com/.json')
		response["data"]["children"].each do |notice|
			author = notice["data"]['author']
			title = notice["data"]['title']
			date = notice["data"]['created']
			url = notice["data"]['url']
			website = 'Reddit'
			notice = Notice.new(author, title, date, url, website)
			feed_reddit.push(notice)
		end
		return feed_reddit
	end
end

class Feed
	def response website
		
		if website == 'Mashable'
			m = Mashable.new
			blog = m.notices
			return blog
		elsif website == 'Reddit'
			r = Reddit.new
			blog = r.notices
			return blog
		elsif website == 'Digg'
			d = Digg.new
			blog = d.notices
			return blog							
		end
	end	
end

class Notice
	attr_accessor :author, :title, :date, :url, :website

	def initialize author, title, date, url, website
		@author = author
		@title = title
		@date = date
		@url = url
		@website = website	
	end
end

def main
	while true
		puts 'Indique sólo el número "1", "2" y "3" ¿Qué website desea ver?'
		puts "'1' para Mashable"
		puts "'2' para Reddit"
		puts "'3' para Digg"
		opt = gets.to_i

		if opt != 1 && opt != 2 && opt != 3
			puts 'opción inválida'
		end

		if opt == 1
			m = Feed.new
			opt = m.response("Mashable")
			break
		elsif opt == 2
			r = Feed.new
			opt = r.response("Reddit")
			break
		else
			d = Feed.new
			opt = d.response("Digg")
			break
		end
	end

	for i in 0...opt.length
		puts "*"*64
		puts opt[i].author
		puts opt[i].title
		puts opt[i].date
		puts opt[i].url
		puts opt[i].website
	end
end
main
