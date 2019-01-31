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

  # Easily grab the URL of any media elements
  def image_url(source)
    asset_url(source)
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
helpers WebpackAssetHelper

###
# s3 Deployment Settings
###
# activate :s3_sync do |s3_sync|
#   s3_sync.bucket                     = '...'           # The name of the S3 bucket you are targeting. This is globally unique.
#   s3_sync.region                     = 'us-east-2'     # The AWS region for your bucket.
#   s3_sync.delete                     = false           # We delete stray files by default.
#   s3_sync.after_build                = false           # We do not chain after the build step by default.
#   s3_sync.prefer_gzip                = true
#   s3_sync.path_style                 = true
#   s3_sync.reduced_redundancy_storage = false
#   s3_sync.acl                        = 'public-read'
#   s3_sync.encryption                 = false
#   s3_sync.prefix                     = 'build'
#   s3_sync.version_bucket             = false
#   s3_sync.index_document             = 'index.html'
#   s3_sync.error_document             = '404.html'
# end

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

activate :external_pipeline,
   name: :webpack,
   command: build? ?
   "BUILD_PRODUCTION=1 ./node_modules/webpack/bin/webpack.js --bail -p" :
   "BUILD_DEVELOPMENT=1 ./node_modules/webpack/bin/webpack.js --watch -d --progress --color",
   source: ".tmp/dist",
   latency: 1

  # SVG Support
  activate :inline_svg

  # GZIP text files
  # activate :gzip

  # Minify HTML on build
  activate :minify_html

  # Append a hash to asset urls (make sure to use the url helpers)
  activate :asset_hash

  # Use relative URLs
  activate :relative_assets

  # Mumford Builder
  # ---------------
  # Cleanup and old files, then run webpack dev mode.
  # Add whatever you need to happen before webpack in the 'build_cleanup.sh' file,
  # and/or load additional scripts to happen after webpack.
  activate :external_pipeline,
    name: :mumford_shell,
    command: build? ? '/usr/local/bin/bash ./build_cleanup.sh' : './node_modules/webpack/bin/webpack.js --watch -d',
    source: ".tmp/dist",
    latency: 1

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
