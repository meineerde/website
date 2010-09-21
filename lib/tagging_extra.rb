# from this thread: http://groups.google.com/group/nanoc/browse_thread/thread/caefcab791fd3c4b

module TaggingExtra

  require 'set'

  #Returns all the tags present in a collection of items.
  #The tags are only present once in the returned value.
  #When called whithout parameters, all the site items
  #are considered.
  def tag_set(items=nil, include_meta=false) 
    items = @items if items.nil?
    items = [items] unless items.is_a? Array
    
    tags = items.collect{|i| i[:tags] || [] }.flatten.uniq!
    include_meta ? tags : tags.select{|tag| not tag.include? ":"}
  end

  #Return true if an items has a specified tag
  def has_tag?(item, tag)
    return false if item[:tags].nil?
    item[:tags].include? tag
  end

  #Finds all the items having a specified tag.
  #By default the method search in all the site
  #items. Alternatively, an item collection can
  #be passed as second (optional) parameter, to
  #restrict the search in the collection.
  def items_with_tag(tag, items=nil)
    items = @items if items.nil?
    items.select { |item| has_tag?( item, tag ) }
  end
  
  #Count the tags in a given collection of items.
  #By default, the method counts tags in all the
  #site items.
  #The result is an hash such as: { tag => count }.
  def count_tags(items=nil)
    items ||= @items
    items = [items] unless items.is_a? Array

    result = Hash.new( 0 )
    @items.each do |item|
      item[:tags].each do |tag|
        result[tag] += 1 unless tag.include? ":"
      end if item[:tags]
    end
    result.default = nil
    result
  end

  #Sort the tags of an item collection (defaults
  #to all site items) in 'n' classes of rank.
  #The rank 0 corresponds to the most frequent
  #tags. The rank 'n-1' to the least frequents.
  #The result is a hash such as: { tag => rank }
  def rank_tags(n, items=nil) 
    items ||= @items
    count = count_tags( items )

    max, min = 0, items.size
    max, min = count.keys.inject([0, items.size]) do |(max, min), t|
      max = count[t] > max ? count[t] : max
      min = count[t] < min ? count[t] : min
      [max, min]
    end
    divisor = ( ( max.to_f - min )  / n )
    divisor = 1 if divisor == 0

    ranks = {}
    count.keys.each do |t|
      rank = n - 1 -  ( count[t] - min ) / divisor
      rank = 0 if rank < 0
      ranks[t] = rank.to_i
    end

    ranks
  end
  
  def link_to_tag(tag, options={})
    link_to(tag, "/tag/#{tag.parameterize("-")}/", options)
  end
  
  def language_tag(item)
    return unless item[:tags]
    item[:tags].find{|tag| tag[5..-1] if tag.start_with? 'lang:'}
  end
end

include TaggingExtra