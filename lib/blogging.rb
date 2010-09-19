module Nanoc3::Helpers::Blogging
  # only include published articles
  def articles
    @items.select { |item| item[:kind] == 'article' && item[:publish] }
  end
end