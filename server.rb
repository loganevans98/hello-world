require 'sinatra'
require 'http'
require 'uri'


get '/' do
  erb :index
end

get '/test' do
  'This is only a test!'
end

get '/giphy' do
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
