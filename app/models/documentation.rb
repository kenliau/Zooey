class Documentation < ActiveRecord::Base
  attr_accessible :content, :title, :permalink, :rendered_content
  validates_uniqueness_of :permalink, :case_sensitive => false
  before_save :render_content
  before_save :generate_permalink


  private
  def generate_permalink
    unless self.blank? or self.title.blank?
      #strip the string
      ret = self.title.strip
      #blow away apostrophes
      ret.gsub! /['`]/,""
      # @ --> at, and & --> and
      ret.gsub! /\s*@\s*/, " at "
      ret.gsub! /\s*&\s*/, " and "
      #replace all non alphanumeric, underscore or periods with dashes
      ret.gsub! /\s*[^A-Za-z0-9\.\_]\s*/, '-'
      #convert double underscores to single
      ret.gsub! /-+/,"-"
      #strip off leading/trailing underscore
      ret.gsub! /\A[-\.]+|[-\.]+\z/,""
      ret.downcase!
      self.permalink = ret
    end
  end

  def render_content
    unless self.blank? or self.content.blank?
      require 'redcarpet'
      renderer = PygmentizeHTML.new({ filter_html: true, hard_wrap: true, with_toc_data: true })
      extensions = { fenced_code_blocks: true, no_intra_emphasis: true }
      redcarpet = Redcarpet::Markdown.new(renderer, extensions)
      self.rendered_content = redcarpet.render self.content
    end
  end

  class PygmentizeHTML < Redcarpet::Render::HTML
    def block_code(code, language)
      require 'pygmentize'
      Pygmentize.process(code, language)
    end
  end

end
