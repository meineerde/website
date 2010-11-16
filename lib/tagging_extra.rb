# from this thread: http://groups.google.com/group/nanoc/browse_thread/thread/caefcab791fd3c4b

require 'set'
module TaggingExtra
  
  def normalize_tag(tag)
    tag.include?(":") ? tag.to_s : tag.parameterize("-").to_s
  end
  
  # Returns all the tags present in a collection of items.
  # The tags are only present once in the returned value.
  # When called whithout parameters, all the site items
  # are considered.
  def tag_set(items=nil, include_meta=false) 
    items ||= @items
    items = [items] unless items.is_a? Array
    
    tags = Hash.new { |hash, key| hash[key] = {:tags => [], :items => [], :count => 0} }
    
    items.each do |item|
      raw_tags = item[:tags] || []
      raw_tags = raw_tags.select{|tag| not tag.include? ":"} unless include_meta
      
      raw_tags.each do |tag|
        t = tags[normalize_tag(tag)]
        t[:tags] |= [tag] # this is a set logic
        t[:items] << item
        t[:count] += 1
      end
    end
    tags  
  end

  # Return true if an items has a specified tag
  def has_tag?(item, tag)
    return false if item[:tags].nil?
    
    tag = normalize_tag(tag)
    !!item[:tags].find{|t| normalize_tag(t) == tag.to_s}
  end
  
  # Finds all the items having a specified tag.
  # By default the method search in all the site
  # items. Alternatively, an item collection can
  # be passed as second (optional) parameter, to
  # restrict the search in the collection.
  def items_with_tag(tag, items=nil)
    items = @items if items.nil?
    items.select { |item| has_tag?( item, tag ) }
  end
  
  # Sort the tags of an item collection (defaults
  # to all site items) in 'n' classes of rank.
  # The rank 0 corresponds to the most frequent
  # tags. The rank 'n-1' to the least frequents.
  # The result is a hash such as: { tag => rank }
  def rank_tags(n, items=nil) 
    items ||= @items
    tags = tag_set( items )

    max, min = tags.inject([0, items.size]) do |(max, min), (t, info)|
      count = info[:count]
      
      max = count if count > max
      min = count if count < min
      [max, min]
    end
    divisor = ( ( max.to_f - min )  / n )
    divisor = 1 if divisor == 0

    tags.each do |tag, info|
      rank = n - 1 -  ( info[:count] - min ) / divisor
      rank = 0 if rank < 0
      info[:rank] = rank.to_i
    end

    tags
  end
  
  def link_to_tag(tag, title, options={})
    link_to(title, "/tag/#{normalize_tag(tag)}/", options)
  end
  
  def language_tag(item)
    return unless item[:tags]
    item[:tags].find{|tag| tag[5..-1] if tag.start_with? 'lang:'}
  end
end

include TaggingExtra