require 'sinatra'
require 'http'
require 'uri'
require 'sinatra/activerecord'
require './config/environments'
require './models/result'

#-------------------#
# Home              #
#-------------------#

get '/' do
  erb :index
end



#-------------------#
# Roulette          #
#-------------------#

get '/roulette' do
	@result = Result.new
	erb :giphy
end

post '/search_giphy' do
	query = params[:query]
	escaped_query = URI.escape(query)
	response = HTTP.get("http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=#{escaped_query}")

	@result = Result.create(query: query, image_url: response.parse["data"]["image_url"])

	erb :giphy
end

get '/results' do
	@results = Result.all.order(created_at: :desc) 
	erb 'results/index'.to_sym
end

get '/results/:id' do
	@result = Result.find params[:id]
	erb :giphy
end



#-------------------#
# Translate         #
#-------------------#

get '/translate' do
	@query = ''
	@image_urls = []
	erb :translate
end

post '/translate_giphy' do
	query = params[:query]
	words = query.split
	image_urls = []
	words.each do |word|
		image_urls.push HTTP.get("http://api.giphy.com/v1/gifs/translate?s=#{word}&api_key=dc6zaTOxFJmzC").parse["data"]["images"]["fixed_height_small"]["url"]
	end

	puts image_urls
	@query = query
	@image_urls = image_urls
	erb :translate
end
