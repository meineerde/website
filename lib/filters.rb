module Nanoc3::Filters
  class Code < Nanoc3::Filter
    identifiers :code
    def run(content, lang=nil)
      return content unless lang
      
      options = {'O' => 'linenos=table'}
      code = Albino.new(content, lang).colorize(options)
      @item[:extension] == 'textile' ? "<notextile>#{code}</notextile>" : code
    end
  end
  
  class CodeSimple < Nanoc3::Filter
    identifiers :code_simple
    def run(content, lang = nil)
      return content unless lang
      
      code = Albino.new(content, lang).colorize()
      @item[:extension] == 'textile' ? "<notextile>#{code}</notextile>" : code
    end
  end
end