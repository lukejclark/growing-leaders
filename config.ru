require './_boot'
require 'rack'
require 'rack/contrib/try_static'
require 'rack/contrib/static_cache'
require 'rack/rewrite'

module Heroku
  class StaticAssetsMiddleware
    def initialize(app)
      @app = app
    end
    def call(env)
      @app.call(env)
    end
  end
end

# Overriding the initialize method of TryStatic so it works within a map method
class Rack::TryStatic
  def initialize(app, options)
    @app = app
    options = options.clone
    @try = ['', *options.delete(:try)]
    @static = ::Rack::Static.new(
        lambda { [404, {}, []] },
        options
    )
  end
end

use Rack::Rewrite do
  rewrite %r{^(/-[A-Za-z0-9]+)?/schools/[A-Za-z0-9-]+([^/].*)?}, '/school$2'
  rewrite %r{^(/-[A-Za-z0-9]+)?/donate/[A-Za-z0-9-]+([^/].*)?}, '/donate$2'
  rewrite %r{^/-[A-Za-z0-9]+(/(.*))?}, '/$2'
end

map '/' do
  if ENV['RACK_ENV'] == 'development'
    require 'middleman'
    run Middleman::Application.server
  else
    use Rack::TryStatic,
        :root => 'build',
        :urls => ['/',''],
        :try  => ['.html', 'index.html', '/index.html']
    use Rack::StaticCache,
        :root => 'build',
        :urls => ['/','']
    run lambda{ |env|
      not_found_page = File.expand_path("../build/404.html", __FILE__)
      if File.exist?(not_found_page)
        [ 404, { 'Content-Type'  => 'text/html'}, [File.read(not_found_page)] ]
      else
        [ 404, { 'Content-Type'  => 'text/html' }, ['File not found!'] ]
      end
    }
  end
end
