require 'sinatra'


configure do
  mime_type :pde, 'text/pde'
end


get '/' do
  /html/snow.html
end

