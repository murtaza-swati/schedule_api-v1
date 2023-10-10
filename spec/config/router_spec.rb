require "test_helper"
require "rack/test"

RSpec.describe Router do
  include Rack::Test::Methods

  def app
    Router
  end

  describe "GET /api/" do
    let(:organization) { create(:organization) }
    let(:token) { AuthToken.issue_token(organization_id: organization.id) }

    context "when authenticated" do
      let(:headers) { {"Authorization" => "Bearer #{token}"} }

      it "responds with 200" do
        get "/api/v1", nil, headers
        expect(last_response).to be_ok
      end
    end

    context "when not authenticated" do
      let(:headers) { {} }

      it "responds with 403" do
        get "/api/v1", nil, headers
        expect(last_response.status).to eq(403)
      end
    end
  end

  describe "POST /exchange_key" do
    let(:api_key) { ApiKeyService.new.generate_api_key }
    let(:organization) { create(:organization, api_key: api_key) }

    before do
      post "/exchange_key", params
    end

    context "when valid params" do
      let(:params) { {email: organization.email, api_key: api_key} }

      it "responds with 200" do
        expect(last_response).to be_ok
      end

      it "returns a token" do
        expect(JSON.parse(last_response.body)).to include("token")
      end
    end

    context "when invalid params" do
      let(:params) { {email: "invalid", api_key: api_key} }

      it "responds with 200" do
        expect(last_response).to be_ok
      end

      it "returns a token" do
        expect(JSON.parse(last_response.body)).to include("error")
      end
    end
  end

  describe "GET /api/v1/doctors/:doctor_id/hours" do
    let(:organization) { create(:organization) }
    let(:token) { AuthToken.issue_token(organization_id: organization.id) }
    let(:doctor) { create(:doctor) }
    let(:headers) { {"Authorization" => "Bearer #{token}"} }

    before do
      get "/api/v1/doctors/#{doctor.id}/hours", nil, headers
    end

    it "responds with 200" do
      expect(last_response).to be_ok
    end

    it "returns the doctor's availability" do
      expect(JSON.parse(last_response.body)).to include("working_hours")
    end
  end
end
