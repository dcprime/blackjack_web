require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

set :sessions, true

get '/template' do 
  erb :text2
end

get '/nested' do
  erb :"/nested/text3"
end