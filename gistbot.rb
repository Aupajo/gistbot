require 'rubygems'
require 'isaac'
require 'open-uri'
require 'net/http'
 
module Gist
  extend self
 
  def write(content, private_gist = false)
    url = URI.parse('http://gist.github.com/gists')
    req = Net::HTTP.post_form(url, data(nil, nil, content, private_gist))
    req['Location']
  end
 
  private
 
  def data(name, ext, content, private_gist)
    return {
      'file_ext[gistfile1]' => ext,
      'file_name[gistfile1]' => name,
      'file_contents[gistfile1]' => content
    }.merge(private_gist ? { 'private' => 'on' } : {})
  end
end

config do |c|
  c.nick    = "GistBot"
  c.server  = "irc.freenode.net"
  c.port    = 6667
end

on :channel, /^\!gist (.*)/ do
  msg channel, Gist.write(match[1])
end

on :private, /\!invite (.*)/ do
  channel_to_join = "##{match[1]}" unless match[1][0] == "#"
  msg nick, "Aye-aye! Deploying to #{channel_to_join}."
  join channel_to_join
end

on :private, /.*/ do
  msg nick, Gist.write(message, :private)
end

