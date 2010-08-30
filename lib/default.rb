# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

def title
  if @item[:title]
    "#{@item[:title]} || #{site_title}"
  else
    site_title
  end
end
  
def site_title
  "meine erde"
end
    
