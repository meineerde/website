# Copy static assets outside of content instead of having nanoc3 process them.
def copy_static
  FileUtils.cp_r 'static/.', 'output/' 
end

# Creates in-memory tag pages from partial: layouts/_tag_page.haml
def create_tag_pages
  tag_set(items).each do |tag|
    items << Nanoc3::Item.new(
      "= render('_tag_page', :tag => '#{tag}')",            # use locals to pass data
      { :title => "Category: #{tag}", :is_hidden => true},  # do not include in sitemap.xml
      "/tag/#{tag.parameterize("-")}/",                     # identifier
      :binary => false
    )
  end
end

# Create archive overview pages
def create_archive_pages
  articles_by_year_month.each do |year, months|
    items << Nanoc3::Item.new(
      "= render('_archive', :items => items_by_year(#{year}))",
      {:title => "#{year}", :is_hidden => true},           # do not include in sitemap.xml
      "/#{year}/",                                         # identifier
      :binary => false
    )
  end
end
