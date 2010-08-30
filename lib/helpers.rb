include Nanoc3::Helpers::Rendering

require 'fileutils'

# Copy static assets outside of content instead of having nanoc3 process them.
def copy_static
  FileUtils.cp_r 'static/.', 'output/'
end