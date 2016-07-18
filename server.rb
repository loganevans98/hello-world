require 'sinatra'
require 'http'
require 'uri'
require 'sinatra/activerecord'
require './config/environments'
require './models/result'


get '/' do
  erb :index
end

get '/test' do
  'This is only a test!'
end

get '/roulette' do
	@query = ''
	@image_url = ''
	erb :giphy  
end

post '/search_giphy' do
	query = params[:query]
	escaped_query = URI.escape(query)
	response = HTTP.get("http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=#{escaped_query}")

	@query = query
	@image_url = response.parse["data"]["image_url"]
	r = Result.new
	r.query = @query
	r.image_url = @image_url
	r.save
	erb :giphy
end
get '/translate' do
	erb :translate, locals: { query: '', image_urls: [] }
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
get '/results' do
	@results = Result.all.order(created_at: :desc) 
	erb 'results/index'.to_sym
end