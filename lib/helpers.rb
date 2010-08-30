include Nanoc3::Helpers::Rendering

require 'fileutils'

# Copy static assets outside of content instead of having nanoc3 process them.
def copy_static
  FileUtils.mkdir_p 'output/assets'
  FileUtils.cp_r 'assets/.', 'output/assets'
end

def site_name
  case @item[:layout]
  when 'blog', nil
    :blog
  when 'hlgr'
    :hlgr
  when 'holgerjust'
    :holgerjust
  else
    raise "Unknown site #{@item[:layout]}"
  end
end

def title
  if @item[:title].nil?
    site_title
  else
    "#{@item[:title]} || #{site_title}"
  end
end
  
def site_title
  case site_name
  when :blog
    "meine erde"
  when :hlgr
    "Hlgr"
  when :holgerjust
    "Holger Just"
  end
end
    
