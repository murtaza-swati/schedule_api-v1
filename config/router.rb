class Router < Sinatra::Base
  helpers Authentication

  before "/api/*" do
    return if authenticated?
    halt 403, {error: errors.join(" ")}.to_json
  end

  get "/api/v1" do
    {message: "pong"}.to_json
  end

  post "/exchange_key" do
    exchange_key.to_json
  end
end
