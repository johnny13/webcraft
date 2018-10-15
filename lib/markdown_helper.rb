# You can define this snippet in `/lib/custom_helpers.rb` file
# More information https://middlemanapp.com/basics/helpers/#custom-defined-helpers
#
module MarkdownHelper

  class Markdown

    class << self
      def renderer
        @@renderer ||= Redcarpet::Markdown.new(
          Redcarpet::Render::HTML,
          :autolink => true,
          :no_intra_emphasis => true,
          :tables => true,
          :fenced_code_blocks => true,
          :filter_html => true,
          :with_toc_data => true
        )
      end
    end

  end

  def markdown(&block)
    content = capture(&block)
    Markdown.renderer.render(content).html_safe
  end

end


# module MarkdownHelper
#
#   require 'middleman-core/renderers/redcarpet'
#
#   class MyRenderer < Middleman::Renderers::MiddlemanRedcarpetHTML
#     def initialize(options={})
#       super
#     end
#   end
#
#   def image(link, title, alt_text)
#     if !@local_options[:no_images]
#       # We add bootstrap centering and responsive class here
#       scope.image_tag(link, title: title, alt: alt_text, class: 'center-block img-responsive')
#     else
#       link_string = link.dup
#       link_string << %("#{title}") if title && !title.empty? && title != alt_text
#       "![#{alt_text}](#{link_string})"
#     end
#   end
# end
