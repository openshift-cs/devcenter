require 'sinatra'
load 'config.rb'

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end
