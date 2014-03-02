require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

set :sessions, true

get '/' do
    "Here is a bunch of text!"
end

get '/otherpage' do
  erb :text2
end
