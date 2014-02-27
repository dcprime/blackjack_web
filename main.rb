require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

set :sessions, true

BLACKJACK_AMOUNT = 21
DEALER_MIN = 17

helpers do

  def calculate_total cards
    arr = cards.map{|e| e[0] }

      @total = 0
      arr.each do |value|
        if value == "A"
          @total += 11
        elsif value.to_i == 0
          @total += 10
        else
          @total += value.to_i
        end
      end

      #correct for Aces
      arr.select{|e| e == "A"}.count.times do
        @total -= 10 if @total > 21
      end
    @total
  end

  def dealer_2nd_card dealer_cards
    second_card = dealer_cards[1]
  end

  def hidden_card
    value = 0
    card = dealer_2nd_card(session[:dealer_cards]).to_s
    if card[2] == "A"
      value = 11
    elsif card[2].to_i == 0
      value = 10
    else
      value = card[2].to_i
    end
    value
  end

  def busted? cards
    calculate_total(cards) > 21
  end

  def dealer_sequence cards
    if calculate_total(cards) < DEALER_MIN
      session[:dealer_cards] << session[:deck].pop
    end
  end

# End helpers method declarations
end

get '/' do
  if session[:username]
    redirect '/game'
  else
    redirect '/set_name'
  end
end

get '/set_name' do
  erb :set_name
end

post '/set_name' do
  session[:username] = params[:username]
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

post '/hit' do
  session[:player_cards] << session[:deck].pop
  @player_busted = busted? session[:player_cards]
  erb :game
end

post '/stay' do

  # Dealer turn goes here
  redirect '/dealer_turn'
end

get '/dealer_turn' do
  dealer_sequence session[:dealer_cards]

  erb :game
end
