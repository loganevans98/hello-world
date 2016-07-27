require 'sinatra'
require 'http'
require 'uri'
require 'sinatra/activerecord'
require './config/environments'
require './models/result'
require './models/query'
require 'obscenity'
require './config/pokemon_names'
require 'dotenv'
require 'json'
Dotenv.load

helpers do
  def protected!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    puts ENV['ADMIN_USERNAME'], ENV['ADMIN_PASSWORD']
    @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == [ENV['ADMIN_USERNAME'], ENV['ADMIN_PASSWORD']]
  end
end

#-------------------#
# Home              #
#-------------------#

get '/' do
  @image_url = Result.limit(1).order("RANDOM()").first.image_url
  erb :index
end



#-------------------#
# Roulette          #
#-------------------#

get '/roulette' do
	@result = Result.new
  @queries = Query.all.order("RANDOM()").limit(24)
	erb 'results/show'.to_sym
end

post '/search_giphy' do
  content_type :json
	query_text = params[:query_text]
	clean_text = Obscenity.replacement(Pokemon::NAMES.sample).sanitize(query_text)
	escaped_text = URI.escape(clean_text)
	response = HTTP.get("http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=#{escaped_text}&rating=pg")
  @query_text = query_text

  no_results = response.parse["data"].empty?

  if no_results
    erb 'results/no_results'.to_sym
  else
  	query = Query.find_or_create_by(text: query_text)
  	@result = Result.create(image_url: response.parse["data"]["image_url"], query_id: query.id)

  	{ image_url: @result.image_url, query_text: query_text }.to_json
  end
end


get '/queries' do
	@queries = Query.all.order(created_at: :desc)
	erb 'queries/index'.to_sym
end

get '/queries/:id' do
	@query = Query.find params[:id]
	erb 'queries/show'.to_sym
end

get '/admin' do
  protected!

  @queries = Query.all.order(created_at: :desc)
  erb 'admin/index'.to_sym
end

delete '/results/:id' do
  protected!
  Query.destroy_result(params[:id])
end

delete '/queries/:id' do
  protected!
  query = Query.find params[:id]
  query.destroy!
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
