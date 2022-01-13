# games class
class GamesController < ApplicationController
  def new
    letters_array = ('a'..'z').to_a
    @letters = letters_array.sample(8)
  end

  def score
  end
end
