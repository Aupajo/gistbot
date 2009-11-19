require 'isaac'
require 'open-uri'
require 'net/http'

module Gist
  extend self
 
  def write(content, private_gist = false)
    url = URI.parse('http://gist.github.com/gists')
    req = Net::HTTP.post_form(url, data(content, private_gist))
    loc = req['Location']
    puts "Gist created at: #{loc}"
    loc
  end
 
  private
 
  def data(content, private_gist)
    return {
      'file_name[gistfile1]' => nil,
      'file_ext[gistfile1]' => nil,
      'file_contents[gistfile1]' => content
    }.merge(private_gist ? { 'private' => 'on' } : {})
  end
end

class MessageLog
  @@logs = {}
  
  def self.find_or_create_for_channel(channel)
    find(channel) || new(channel)
  end
  
  def self.find(channel)
    @@logs[channel]
  end
  
  def initialize(channel)
    @started_at = Time.now.gmtime
    @channel = channel
    @messages = []
    @@logs[channel] = self
  end
  
  def add(nick, msg)
    @messages << '[' + Time.now.gmtime.strftime('%I:%M%p') + "] <#{nick}> #{msg}"
  end
  
  def read(lines)
    lines = @messages.size if lines > @messages.size
    output = "Channel #{@channel} at #{@started_at.to_s}\n\n"
    output << @messages[-lines, lines].join("\n")
    output << "\n\nLogging finished at: #{Time.now.gmtime.to_s}\n\n"
    output << "Translate time: #{date_link}"
  end
  
  def date_link
    "http://timeanddate.com/worldclock/fixedtime.html?" +
    "day=#{@started_at.day}" +
    "&month=#{@started_at.month}" +
    "&year=#{@started_at.year}" +
    "&hour=#{@started_at.hour}"+ 
    "&min=#{@started_at.min}" +
    "&sec=#{@started_at.hour}" +
    "&p1=136" # UTC
  end
end

configure do |c|
  c.nick    = "GistBot"
  c.server  = "irc.freenode.net"
  c.port    = 6667
end

helpers do
  def channel_name_for(room)
    room[0,1] == "#" ? room : "#" + room
  end
  
  def log(channel, nick, msg)
    log = MessageLog.find_or_create_for_channel(channel)
    log.add(nick, msg)
  end
  
  def log_lines(channel, num)
    log = MessageLog.find(channel)
    log.read(num.to_i)
  end
end

on :channel, /^\!gist log (\d+)/ do
  msg channel, "Chat log gist created! " + Gist.write(log_lines(channel, match[1]))
end

on :channel, /^\!gist (.*)/ do
  msg channel, "Gist created! " + Gist.write(match[1])
end

on :channel, /.*/ do
  log channel, nick, message 
end

on :private, /^\!invite (.*)/ do
  channel_name = channel_name_for(match[1])
  msg nick, "Aye-aye! Deploying to #{channel_name}"
  puts "Joining #{channel_name}"
  join channel_name
end

on :private, /^\!leave (.*)/ do
  channel_name = '#' + match[1] unless match[1][0,1] == "#"
  msg nick, "Roger that. Leaving #{channel_name}"
  puts "Leaving #{channel_name}"
  part channel_name
end

on :private, /.*/ do
  msg nick, Gist.write(message, :private)
end

