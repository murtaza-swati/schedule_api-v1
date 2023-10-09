class Router < Sinatra::Base
  before do
    halt 403 unless authorized?
  end

  get "/" do
    HomeController.new.index
  end

  helpers do
    def authorized?
      true
    end
  end
end
