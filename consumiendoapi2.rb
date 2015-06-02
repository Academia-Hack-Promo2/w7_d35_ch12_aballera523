#!/usr/bin/ruby
# -*- coding: utf-8 -*-
require 'httparty'

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

class Mashable
  include HTTParty
  base_uri 'http://mashable.com/stories.json'

  def notices
    notices_mashable = Array.new
    response = HTTParty.get('http://mashable.com/stories.json')
    response["new"].each do |notice|
      author = notice['author']
      title = notice['title']
      date = notice['post_date']
      url = notice['link']
      website = 'Mashable'
      notice = Notice.new(author, title, date, url, website)
      notices_mashable.push(notice)
    end
    return notices_mashable
  end
end

class Reddit
  include HTTParty
  base_uri 'http://www.reddit.com/.json'

  def notices
    notices_reddit = Array.new
    response = HTTParty.get('http://www.reddit.com/.json')
    response["data"]["children"].each do |notice|
      author = notice["data"]['author']
      title = notice["data"]['title']
      date = Time.at(notice["data"]['created'])
      url = notice["data"]['url']
      website = 'Reddit'
      notice = Notice.new(author, title, date, url, website)
      notices_reddit.push(notice)
    end
    return notices_reddit
  end
end

class Digg
  include HTTParty
  base_uri 'http://digg.com/api/news/popular.json'

  def notices
    notices_digg = Array.new
    response = HTTParty.get('http://digg.com/api/news/popular.json')
    response["data"]["feed"].each do |notice|
      author = notice["content"]['author']
      title = notice["content"]['title']
      date = Time.at(notice['date'])
      url = notice["content"]['url']
      website = 'Digg'
      notice = Notice.new(author, title, date, url, website)
      notices_digg.push(notice)
    end
    return notices_digg
  end
end


class Feed
  def response website
    if website == 'Mashable'
      mashable = Mashable.new
      notices_mashable = mashable.notices
      return notices_mashable
    elsif website == 'Reddit'
      reddit = Reddit.new
      notices_reddit = reddit.notices
      return notices_reddit
    elsif website == 'Digg'
      digg = Digg.new
      notices_digg = digg.notices
      return notices_digg
    end
  end
end

def main
  while true
    puts 'Indique sólo el número "1", "2" y "3" ¿Qué website desea ver?'
    puts "'1' para Mashable"
    puts "'2' para Reddit"
    puts "'3' para Digg"
    option = gets.to_i

    if option == 1
      mashable = Feed.new
      option = mashable.response("Mashable")
      break
    elsif option == 2
      reddit = Feed.new
      option = reddit.response("Reddit")
      break
    elsif option == 3
      digg = Feed.new
      option = digg.response("Digg")
      break
    else
      puts 'Opción Inválida Seleccione "1", "2" o "3" '
      break
    end
  end

  for i in 0...option.length
    puts "*"*64
    puts option[i].author
    puts option[i].title
    puts option[i].date
    puts option[i].url
    puts option[i].website
  end
end
main
