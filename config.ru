require 'rubygems'
require 'bundler/setup'
load 'config.rb'

#require 'rake'
require 'app.rb'
run Sinatra::Application
