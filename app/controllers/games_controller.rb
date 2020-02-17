require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    grid_size = 10
    i = 0
    letter_array = ("A".."Z").to_a
    @letters = []
    while i < grid_size.to_i
      @letters.push(letter_array.sample)
      i += 1
    end
  end

  def score


    @attempt = params['word'].upcase
    url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    word_serialized = open(url).read
    word = JSON.parse(word_serialized)
    @grid = params['letters'].upcase
    array_attempt = @attempt.split('')
    array_grid = @grid.split(' ')
    array_attempt.sort
    array_grid.sort

    letter_count = Hash.new(0)
    array_attempt.each { |v| letter_count[v] += 1 }

    grid_count = Hash.new(0)
    array_grid.each { |v| grid_count[v] += 1 }

    if word['found'] == false
      @answer = "Sorry but #{@attempt} does not seem to be a valid English word..."
    elsif array_attempt.all? { |i| letter_count[i] <= grid_count[i] } != true
      @answer = "Sorry but #{@attempt} can't be build out of #{array_grid.join(', ')}"
    else
      @answer = "Congratulations! #{@attempt} is a valid English word!"
    end
  end
end
