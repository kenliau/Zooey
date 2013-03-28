class Documentation < ActiveRecord::Base
  attr_accessible :content, :title, :permalink, :rendered_content
  validates_uniqueness_of :permalink, :case_sensitive => false
  before_save :render_content


  private
  def render_content
    require 'redcarpet'
    renderer = PygmentizeHTML.new({ filter_html: true, hard_wrap: true, with_toc_data: true })
    extensions = { fenced_code_blocks: true, no_intra_emphasis: true } 
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    self.rendered_content = redcarpet.render self.content
  end

  class PygmentizeHTML < Redcarpet::Render::HTML
    def block_code(code, language)
      require 'pygmentize'
      Pygmentize.process(code, language)
    end
  end

end
