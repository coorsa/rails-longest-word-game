# frozen_string_literal: true

require 'open-uri'
require 'json'

# games class
class GamesController < ApplicationController
  def new
    @letters = letter_grid(10)
    @start_time = Time.now
  end

  def score
    # get data from game
    original_grid = params[:grid]
    @word = params[:word]
    start_time = Time.parse(params[:start_time])
    end_time = Time.now

    @result = run_game(@word, original_grid, start_time, end_time)
  end

  private

  def letter_grid(grid_size)
    Array.new(grid_size) { ('A'..'Z').to_a[rand(26)] }
  end

  def timer(start_time, end_time)
    end_time - start_time
  end

  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
    result_hash = { time: timer(start_time, end_time), score: 0, message: 'empty' }
    # result_hash[:time] = timer(start_time, end_time)
    if in_the_grid?(attempt.upcase, grid) == false
      result_hash[:message] = 'not in the grid'
    elsif valid_word?(attempt) && in_the_grid?(attempt.upcase, grid)
      result_hash[:score] = 50 - result_hash[:time] + attempt.length
      result_hash[:message] = 'Well Done, Sir!'
    else
      result_hash[:message] = 'Not an English Word!'
    end
    result_hash
  end

  def valid_word?(word)
    # check if word only uses unique chars from random array
    # if yes, check if english word
    # if not, --> game lost, score 0, message explanation (pass on to score method)
    # english word check with dictionary
    # if found --> pass on to score method (or call valid_word inside score method)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    dictionary_serialized = URI.open(url).read
    dictionary = JSON.parse(dictionary_serialized)
    dictionary['found'] == true
  end

  def in_the_grid?(word, original_grid)
    word.chars.all? { |letter| original_grid.include?(letter) && word.count(letter) <= original_grid.count(letter) }
  end
end
