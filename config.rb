###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (https://middlemanapp.com/advanced/dynamic_pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# configure :development do
#   activate :livereload
# end

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

require 'premailer'  
class InlineCSS < Middleman::Extension  
  def initialize(app, options_hash={}, &block)
    super
    app.after_build do |builder|
      Dir.glob(build_dir + File::SEPARATOR + '*.html').each do |source_file|
        premailer = Premailer.new(source_file, verbose: true)
        destination_file = source_file.gsub('.html', '-inline.html')

        puts "Inlining file: #{source_file} to #{destination_file}"

        File.open(destination_file, "w") do |content|
          content.puts premailer.to_inline_css
        end
      end
    end
  end
end  
::Middleman::Extensions.register(:inline_css, InlineCSS)


# Build-specific configuration
configure :build do
  configure :build do  
    activate :inline_css
  end 
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end
