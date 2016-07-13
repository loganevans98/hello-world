require 'sinatra'
require 'http'
require 'uri'


get '/' do
  erb :index
end

get '/test' do
  'This is only a test!'
end

get '/roulette' do
	erb :giphy, locals: { query: '', image_url: '' }
end

post '/search_giphy' do
	query = params[:query]
	escaped_query = URI.escape(query)
	response = HTTP.get("http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=#{escaped_query}")

	erb :giphy, locals: {
							query: query,
							image_url: response.parse["data"]["image_url"]
						}
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
	erb :translate, locals: {
							query: query,
							image_urls: image_urls
						}
end