#!/usr/bin/env ruby

# Copyright (c) 2010 Holger Just <web@meine-er.de>
# 
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

require 'twitter'
require 'time'
require 'bigdecimal' # for infinity implementation

# Configuration
twitter_user = 'meineerde' # Change to your Twitter username
fetch_tweets = 5           # Number of tweets to fetch
output_file = File.join(File.dirname(__FILE__), "..", "_includes", "twitter.html")

def pretty_date(time)
  # The base for this function is taken from
  # http://evaisse.com/post/93417709/python-pretty-date-function
  
  diff = Time.now - time
  
  case diff.round
  when BigDecimal.new("-Infinity")..0
    "sometime in the future"
  when 0..10
    "just now"
  when 11..59
    "#{diff} seconds ago"
  when 60..3600
    d = (diff / 60).round
    "about #{d == 1 ? 'a' : d} minute#{'s' unless d == 1} ago"
  when 3600..(3600*24)
    d = (diff / 3600).round
    "about #{d == 1 ? 'an' : d} hour#{'s' unless d == 1} ago"
  when (3600*24)..(3600*24*2)
    "Yesterday"
  when (3600*24*2)..(3600*24*7)
    "about #{(diff / 3600 / 24).round} days ago"
  when (3600*24*7)..(3600*24*31)
    d = (diff / 3600 / 24 / 7).round
    "about #{d == 1 ? 'a' : d} week#{'s' unless d == 1} ago"
  when (3600*24*31)..(3600*24*365)
    d = (diff / 3600 / 24 / 30).round
    "about #{d} month#{'s' unless d == 1} ago"
  else
    d = (diff / 3600 / 24 / 30).round
    "about #{d == 1 ? 'a' : d} year#{'s' unless d == 1} ago"
  end
end

tweets = Twitter::Search.new.from(twitter_user).per_page(fetch_tweets).entries
exit 1 if tweets.empty?

result = ['<ul id="twitter_list" class="hfeed">']
tweets.each do |t|
  d = Time.parse(t.created_at)
  
  text = t.text
  # from http://daringfireball.net/2010/07/improved_regex_for_matching_urls
  url_regex = /(?i)\b((?:[a-z][\w-]+:(?:\/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}\/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'".,<>?«»“”‘’]))/
  text.gsub!(url_regex, '<a href="\1">\1</a>')
  
  # link hash tags
  text.gsub!(/(\A|\s+)#([\w]+)/, '\1<a class="twitter_hash" rel="tag" href="http://search.twitter.com/search?q=%23\2">#\2</a>')
  # link users
  text.gsub!(/(\A|\s+)@([\w\-]+)/, '\1<a class="twitter_user" href="http://twitter.com/\2">@\2</a>')
  
  # get display name of user
  user_name = Twitter.user(t.from_user).name rescue t.from_user
  
  status_url = "http://twitter.com/#{twitter_user}/#{t.id}"
  result << '  <li class="hentry">'
  result << '    <address class="vcard author hidden">'
  result << "      <a class=\"url fn\" href=\"http://twitter.com/#{t.from_user}\">#{user_name}</a>"
  result << '    </address>'
  result << "    <a class=\"twitter_date\" href=\"#{status_url}\" rel=\"bookmark\"><abbr class=\"published\" title=\"#{d.iso8601}\">#{pretty_date(d)}</abbr></a>"
  result << "    <span class=\"entry-content\">#{text}</span>"
  result << '  </li>'
end
result << "</ul>"

File.open(output_file, 'w') do |out|
  out.write(result.join("\n"))
end