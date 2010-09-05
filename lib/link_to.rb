module LinkTo
  def link_to_previous(item)
    previous = next_item(item, 1)
    link_to("« #{previous[:title]}", previous, :title => "Previous Article") if previous
  end

  def link_to_next(item)
    nxt = next_item(item, -1)
    link_to("#{nxt[:title]} »", nxt, :title => "Next Article") if nxt
  end

private

  def next_item(item, direction = 1)
    items = sorted_articles
    id = items.index(item)

    return nil if id.nil?
    case
    when direction < 0
      id < (direction * -1) ? nil : items[id + direction]
    when direction > 0
      id > (items.length - direction) ? nil : items[id + direction]
    else
      item
    end
  end
end

include LinkTo