require "test_helper"
require "rack/test"

RSpec.describe Router do
  include Rack::Test::Methods

  def app
    Router
  end

  context "GET /" do
    context "when authorized" do
      # Mock or setup the authorization to succeed
      before do
        allow_any_instance_of(Router).to receive(:authorized?).and_return(true)
      end

      it "responds with 200" do
        get "/"
        expect(last_response).to be_ok
      end
    end

    context "when not authorized" do
      # Mock or setup the authorization to fail
      before do
        allow_any_instance_of(Router).to receive(:authorized?).and_return(false)
      end

      it "responds with 403" do
        get "/"
        expect(last_response.status).to eq(403)
      end
    end
  end
end
