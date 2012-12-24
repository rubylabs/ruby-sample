require 'sinatra'


configure do
  mime_type :pde, 'text/pde'
end


get '/' do
  "Hello, world 6"
end

get '/hi' do
  "Hello World!"
end
