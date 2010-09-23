# Copy static assets outside of content instead of having nanoc3 process them.
def copy_static
  FileUtils.cp_r 'static/.', 'output/' 
end

# Creates in-memory tag pages from partial: layouts/_tag_page.haml
def create_tag_pages
  tag_set(articles).each do |tag|
    items << Nanoc3::Item.new(
      "= render('_tag_page', :tag => '#{tag}')",            # use locals to pass data
      { :title => "Category: #{tag}", :is_hidden => true},  # do not include in sitemap.xml
      "/tag/#{tag.parameterize("-")}/",                     # identifier
      :binary => false
    )
  end
end

# Create language tag pages
def create_language_pages
  titles = {
    'en' => "English Articles",
    'de' => "Deutsche Artikel"
  }
  
  tags = tag_set(articles, true).select{|t| t.start_with? 'lang:'}
  tags.each do |tag|
    lang = tag[5..-1]
    items << Nanoc3::Item.new(
      "= render('_language_page', :tag => '#{tag}', :title => '#{titles[lang]}')",
      {:title => titles[lang], :is_hidden => true},         # do not include in sitemap.xml
      "/#{lang}/",                                          # identifier
      :binary => false
    )
  end
end

# Create archive overview pages
def create_archive_pages
  articles_by_year_month.each do |year, months|
    items << Nanoc3::Item.new(
      "= render('_archive', :items => items_by_year(#{year}))",
      {:title => "#{year}", :is_hidden => true},            # do not include in sitemap.xml
      "/#{year}/",                                          # identifier
      :binary => false
    )
  end
end
