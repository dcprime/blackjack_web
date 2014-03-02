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
    calculate_total(cards) > BLACKJACK_AMOUNT
  end

  def dealer_sequence
  @player_turn = false
    if busted? session[:dealer_cards]
      @selection = true
      @compare = false
    elsif calculate_total(session[:dealer_cards]) < DEALER_MIN
      @selection = false
      @compare = false
    else # Dealer's hand is between 17 and 21
      @selection = true
      @compare = true
    end
  end

def get_image(card)
    suit = case card[1]
        when "C" then 'clubs'
        when "D" then 'diamonds'
        when "S" then 'spades'
        when "H" then 'hearts'
      end

    value = card[0]
    if ['J', 'Q', 'K', 'A'].include?(value)
      value = case card[0]
        when "J" then 'jack'
        when "Q" then 'queen'
        when "K" then 'king'
        when "A" then 'ace'
      end 
    end 
    "<img src='/images/cards/#{suit}_#{value}.jpg'   width='84' hight='122'>"
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
  if params[:username].empty?
    @error = "Player name cannot be empty! Please enter a name."
    halt erb(:set_name)
  end
  session[:username] = params[:username]
  redirect '/game'
end

get '/game' do
  suits = ['H', 'D', 'S', 'C']
  values = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
  session[:deck] = values.product(suits).shuffle!
  session[:player_cards] = []
  session[:dealer_cards] = []
  2.times do
    session[:dealer_cards] << session[:deck].pop
    session[:player_cards] << session[:deck].pop
  end
  @player_turn = true
  @player_bust = false
  @selection = false
  @compare = false
  erb :game
end

post '/hit' do
  session[:player_cards] << session[:deck].pop
  @player_busted = busted? session[:player_cards]
    if @player_busted
      @player_turn = false
      @selection = true
      @compare = false
    else
      @player_turn = true
      @selection = false
      @compare = false
    end
  erb :game
end

post '/stay' do
  dealer_sequence
  erb :game
end

post '/dealer_hit' do
  session[:dealer_cards] << session[:deck].pop
  dealer_sequence
  erb :game
end

post '/replay' do
  redirect '/game' 
end

post '/exit' do
  erb :exit
end
