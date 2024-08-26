require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('a'..'z').to_a.sample }
    session[:letters] = @letters
  end

  def score
    @answer = params[:answer]
    @letters = session[:letters]

    if valid_word?(@answer)
      @result = "¡Buena respuesta en ingles!"
    else
      @result = "Respuesta incorrecta. Inténtalo de nuevo."
    end
  end

  private

  def valid_word?(word)
    api_url = "https://dictionary.lewagon.com/#{word}"
    begin
      respuesta = URI.open(api_url).read
      datos = JSON.parse(respuesta)
      datos['found']
    rescue StandardError => e
      Rails.logger.error("Error en la solicitud a la API: #{e.message}")
      false
    end
  end
end
