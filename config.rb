###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page "/path/to/file.html", layout: :otherlayout

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
# which_fake_page: "Rendering a fake page with a local variable" }

###
# Helpers
###
# Methods defined in the helpers block are available in templates
helpers do
  def page_title
    current_page.data.title
  end

  def markdown(text)
    Tilt['markdown'].new { text }.render
  end
end

activate :syntax, :line_numbers => true

###
# Markdown Rendering
###

require "lib/pages_nav_helper"
require "lib/font_awesome_helper"
require "lib/markdown_helper"
helpers MarkdownHelper
helpers CustomHelpers
helpers FontAwesomeHelper

###
# Environment List
###

# Server Environment
configure :server do

  # Debug assets
  set :debug_assets, true

end

# Development Environment
configure :development do

  #To activate the middleman-sprockets
  require 'sprockets/es6'
  activate :sprockets do |s|
    s.supported_output_extensions << '.es6'
  end
  sprockets.append_path File.join(root, "node_modules")


  # Automatic image dimensions on image_tag helpers
  activate :automatic_image_sizes

  # Autoprefixer
  activate :autoprefixer do |prefix|
    prefix.browsers = "last 3 versions"
  end

  # Reload the browser automatically whenever files change
  activate :livereload, :no_swf => true, livereload_css_target:true

  # Assets Pipeline Sets
  set :css_dir, 'assets/stylesheets'
  set :js_dir, 'assets/javascripts'
  set :images_dir, 'assets/images'
  set :fonts_dir, 'assets/fonts'

  # Pretty URLs
  activate :directory_indexes

  # SVG Support
  activate :inline_svg

end

# Build Environment
configure :build do

  #To activate the middleman-sprockets
  require 'sprockets/es6'
  activate :sprockets do |s|
    s.supported_output_extensions << '.es6'
  end
  sprockets.append_path File.join(root, "node_modules")

  # Autoprefixer
  activate :autoprefixer do |prefix|
    prefix.browsers = "last 3 versions"
  end

  # SVG Support
  activate :inline_svg

  # Minify CSS on build
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # GZIP text files
  # activate :gzip

  # Minify HTML on build
  activate :minify_html

  # Append a hash to asset urls (make sure to use the url helpers)
  activate :asset_hash

  # Use relative URLs
  activate :relative_assets

end

# Production Environment
configure :production do

  # Assets Pipeline Sets
  set :css_dir, 'assets/stylesheets'
  set :js_dir, 'assets/javascripts'
  set :images_dir, 'assets/images'
  set :fonts_dir, 'assets/fonts'

  # Middleman Production dev server run code
  # 'middleman server -e production'

end
