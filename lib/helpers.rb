require 'builder'
require 'fileutils'
require 'time'

# Hyphens are converted to sub-directories in the output folder.
#
# If a file has two extensions like Rails naming conventions, then the first extension
# is used as part of the output file.
#
#   sitemap.xml.erb # => sitemap.xml
#
# If the output file does not end with an .html extension, item[:layout] is set to 'none'
# bypassing the use of layouts.
# 
def route_path(item)
  # don't mess with binary data
  return item.identifier.chop + '.' + item[:extension] if item.binary?
  # in-memory items have not file
  return item.identifier + "index.html" if item[:content_filename].nil?
  
  if item[:kind] == 'article'
    time = item[:created_at]
    time = time.is_a?(String) ? Time.parse(time) : time
    
    filename = item[:content_filename].scan(/[^\/]+$/)[0]
    filename.gsub!(/\.[a-zA-Z0-9]+$/, '') # remove extension
    filename.gsub!(/^(\d+-)+/, '') # remove leading date information
    
    "/#{time.strftime('%Y/%m')}/#{filename}/index.html"
  else
    item.identifier + "index.html"
  end
end

def partial(identifier_or_item)
  item = !item.is_a?(Nanoc3::Item) ? identifier_or_item : item_by_identifier(identifier_or_item)
  item.compiled_content(:snapshot => :pre) 
end

def item_by_identifier(identifier)
  items ||= @items
  items.find { |item| item.identifier == identifier }
end

#=> { 2010 => { 12 => [item0, item1], 3 => [item0, item2]}, 2009 => {12 => [...]}}
def articles_by_year_month(items = nil)
  result = {}
  current_year = current_month = year_h = month_a = nil
  
  articles = items ? (sorted_articles & items) : sorted_articles

  articles.each do |item|
    d = Date.parse(item[:created_at])
    if current_year != d.year
      current_month = nil
      current_year = d.year
      year_h = result[current_year] = {}
    end

    if current_month != d.month
      current_month = d.month
      month_a = year_h[current_month] = [] 
    end

    month_a << item
  end

  result
end

def items_by_year(year)
  articles_by_year_month[year.to_i].collect{|k, v| v}.flatten
end

def is_front_page?
    @item.identifier == '/'
end


def n_newer_articles(n, reference_item)
  @sorted_articles ||= sorted_articles
  index = @sorted_articles.index(reference_item)
  
  # n = 3, index = 4
  if index >= n
    @sorted_articles[index - n, n]
  elsif index == 0
    []
  else # index < n
    @sorted_articles[0, index]
  end
end


def n_older_articles(n, reference_item)
  @sorted_articles ||= sorted_articles
  index = @sorted_articles.index(reference_item)
  
  # n = 3, index = 4, length = 6
  length = @sorted_articles.length
  if index < length
    @sorted_articles[index + 1, n]
  else
    []
  end
end


def site_name
  @config[:site_name]
end

def time(time, format)
  Time.parse(time).strftime(format) unless time.nil?
end


def to_month_s(month)
  Date.new(2010, month).strftime("%B")
end

private

def derive_created_at(item)
  parts = item.identifier.gsub('-', '/').split('/')[1,3]
  date = '1980/1/1'
  begin
    Date.strptime(parts.join('/'), "%Y/%m/%d")
    date = parts.join('/')
  rescue
  end
  date
end
