require 'open-uri'
require 'json'

class GamesController < ApplicationController
  before_action :update_total_score

  def new
    generate_letters
  end

  def score
    @message = in_the_grid? ? valid_word? : 'Sorry, your word is not in the grid. Try again!'
    final_points
    update_total_score
  end

  private

  def generate_letters
    @letters = []
    random_letters = ('A'..'Z').to_a
    random_letters.each { |_| @letters << random_letters.sample until @letters.length == 10 }
  end

  def in_the_grid?
    @letters = params[:letters].split
    letters = params[:word].upcase.chars
    letters.all? { |letter| letters.count(letter) <= @letters.count(letter) }
  end

  def valid_word?
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    response = URI.parse(url)
    check = JSON.parse(response.read)
    if check['found'] == true
      @message = 'Well done!'
    else
      @message = 'Sorry, your word is not an english word. Try again!'
    end
    @message
  end

  def final_points
    if in_the_grid? && @message == 'Well done!'
      @score = params[:word].length
      @score += 5 if params[:word].length > 3
      @score += 10 if params[:word].length > 5
    else
      @score = 0
    end
    @score
  end

  def update_total_score
    @total_score = 0
    @total_score += params[:score].to_i
  end
end
