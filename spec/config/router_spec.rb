require "test_helper"
require "rack/test"

RSpec.describe Router do
  include Rack::Test::Methods

  let(:organization) { create(:organization) }
  let(:token) { AuthToken.issue_token(organization_id: organization.id) }
  let(:headers) { {"Authorization" => "Bearer #{token}"} }

  def app
    Router
  end

  describe "GET /api/" do
    context "when authenticated" do
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
    let(:organization) { create(:organization, api_key: api_key) }
    let(:api_key) { ApiKeyService.new.generate_api_key }

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
    let(:doctor) { create(:doctor) }

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

  describe "GET /api/v1/doctors/:doctor_id/availability" do
    let(:doctor) { create(:doctor) }

    before do
      get "/api/v1/doctors/#{doctor.id}/availability", query_params, headers
    end

    context "with start and end date" do
      let(:query_params) { {start_date: "2019-01-01", end_date: "2019-01-2"} }

      it "responds with 200" do
        expect(last_response).to be_ok
      end

      it "returns the doctor's availability" do
        expect(JSON.parse(last_response.body)).to include("01-01-2019", "02-01-2019")
        expect(JSON.parse(last_response.body)).not_to include("03-01-2019")
      end
    end

    context "with start date only" do
      let(:query_params) { {start_date: "2019-01-01"} }

      it "responds with 200" do
        expect(last_response).to be_ok
      end

      it "returns the doctor's availability" do
        expect(JSON.parse(last_response.body)).to include("01-01-2019", "07-01-2019")
      end
    end
  end

  describe "POST /api/v1/doctors/:doctor_id/appointments" do
    let(:doctor) { create(:doctor) }

    before do
      post "/api/v1/doctors/#{doctor.id}/appointments", params, headers
    end

    context "with valid params" do
      context "with multiple appointments" do
        let(:params) do
          {
            appointments: [
              {
                patient_name: "John Doe",
                start_time: "2019-01-01 09:00 AM UTC"
              },
              {
                patient_name: "Jane Doe",
                start_time: "2019-01-01 10:00 AM UTC"
              }
            ]
          }
        end

        it "responds with 200" do
          expect(last_response).to be_ok
        end

        it "creates the appointments" do
          expect(Appointment.count).to eq(2)
        end

        xit "returns the appointments" do
          expect(JSON.parse(last_response.body)).to include("John Doe", "Jane Doe")
        end
      end

      context "with a single appointment" do
        let(:params) do
          {appointment: {patient_name: "John Doe", start_time: "2019-01-01 09:00 AM UTC"}}
        end

        it "responds with 200" do
          expect(last_response).to be_ok
        end

        it "creates the appointment" do
          expect(Appointment.count).to eq(1)
        end

        xit "returns the appointment" do
          expect(JSON.parse(last_response.body)).to include("John Doe")
        end
      end
    end
  end
end
