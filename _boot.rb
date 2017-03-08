ENV['RACK_ENV'] ||= 'development'
####################################################################################

$: << File.expand_path('../', __FILE__)

require 'bundler'
Bundler.require(:default, ENV['RACK_ENV'].to_sym)

I18n.default_locale = :en
