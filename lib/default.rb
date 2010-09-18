# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

include Nanoc3::Helpers::Blogging
include Nanoc3::Helpers::Capturing
include Nanoc3::Helpers::Filtering
include Nanoc3::Helpers::LinkTo
include Nanoc3::Helpers::Rendering
include Nanoc3::Helpers::XMLSitemap

%w(twitter_username disqus_shortname).each do |cfg|
  eval <<-EOF
    def #{cfg}
      @config[:#{cfg}]
    end
  EOF
end
