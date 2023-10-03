
class Router < Sinatra::Base
  get '/' do
    ::Home.new.index
  end
end

