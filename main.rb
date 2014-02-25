require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

set :sessions, true

get '/' do
  erb :set_name
end

post '/set_name' do
  session[:username] = params[:username]
  redirect '/bet'
end

get '/bet' do
  session[:bank] = 500
  erb :bet
end

post '/bet' do
  session[:bet_amount] = params[:bet_amount].to_i
  session[:bank] = session[:bank] - session[:bet_amount]
  redirect '/game'
end

get '/game' do
  
  suits = ['H', 'D', 'S', 'C']
  values = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
  session[:deck] = values.product(suits).shuffle!
  session[:player_cards] = []
  session[:dealer_cards] = []
  session[:player_cards] << session[:deck].pop
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop
  session[:dealer_cards] << session[:deck].pop
  erb :game
end