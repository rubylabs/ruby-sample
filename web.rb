require 'sinatra'


configure do
  mime_type :pde, 'text/pde'
end


get '/' do
  redirect "/html/snow.html"
end

