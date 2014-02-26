require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

set :sessions, true

BLACKJACK_AMOUNT = 21
DEALER_MIN = 17
START_BALANCE = 500

get '/' do
  if session[:username]
    redirect '/bet'
  else
    redirect '/set_name'
  end
end

get '/set_name' do
  erb :set_name
end

post '/set_name' do
  session[:username] = params[:username]
  redirect '/bet'
end

get '/bet' do
  session[:bank] = START_BALANCE
  erb :bet
end

post '/bet' do
  session[:bet_amount] = params[:bet_amount].to_i
  session[:bank] = session[:bank] - session[:bet_amount]
  redirect '/game'
end

get '/game' do
  if !session[:player_cards]
    suits = ['H', 'D', 'S', 'C']
    values = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
    session[:deck] = values.product(suits).shuffle!
    session[:player_cards] = []
    session[:dealer_cards] = []
    session[:dealer_cards] << session[:deck].pop
    session[:player_cards] << session[:deck].pop
    session[:dealer_cards] << session[:deck].pop
    session[:player_cards] << session[:deck].pop
  end



  erb :game
end