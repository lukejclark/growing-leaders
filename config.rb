require './_boot'

###
# HAML
###

set :haml, :format => :html5, :escape_attrs => false

###
# Page options, layouts, aliases and proxies
###

page '*', :layout => :layout
page 'directives/*', :layout => false
page 'template/*', :layout => false

###
# Helpers
###

helpers do
  def nav_active(page)
    @page_id == page ? {:class => "active"} : {}
  end

  def ng_app(ng_app=nil)
    (ng_app.blank?) ? (@ng_app ||= 'app') : @ng_app = ng_app.to_s
  end

  def general_tweet_url
    'https://twitter.com/intent/tweet?text=Help%20me%20bring%20%23Habitudes%20to%20Georgia%20and%20prepare%20the%20next%20generation%20of%20leaders!&url=&hashtags=GrowingLeadersForGA'
  end

  def school_tweet_url
    'https://twitter.com/intent/tweet?text=Help%20me%20bring%20%23Habitudes%20to%20{{school.name}}%20and%20prepare%20the%20next%20generation!&url=&hashtags=GrowingLeadersForGA'
  end

end

activate :directory_indexes

# Asset Paths
set :css_dir,       'assets/css'
set :js_dir,        'assets/js'
set :images_dir,    'assets/img'

# Build-specific configuration
configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :gzip
end

require './env' if File.exists?('env.rb')
