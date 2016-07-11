require 'sinatra'

get '/' do
  erb :index
end

get '/test' do
  'This is only a test!'
end

