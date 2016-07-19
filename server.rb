require 'sinatra'
require 'http'
require 'uri'
require 'sinatra/activerecord'
require './config/environments'
require './models/result'
require './models/query'

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
	erb 'results/show'.to_sym
end

post '/search_giphy' do
	query_text = params[:query_text]
	escaped_text = URI.escape(query_text)
	response = HTTP.get("http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=#{escaped_text}")
	@query_text = query_text
	query = Query.create(text: query_text )
	@result = Result.create(image_url: response.parse["data"]["image_url"], query_id: query.id)
	

	erb 'results/show'.to_sym
end

get '/queries' do
	@queries = Query.all.order(created_at: :desc) 
	erb 'queries/index'.to_sym
end

get '/queries/:id' do
	@query = Query.find params[:id]
	erb 'queries/show'.to_sym
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



