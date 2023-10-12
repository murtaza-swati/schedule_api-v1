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

        it "responds with 201" do
          expect(last_response).to be_created
        end

        it "creates the appointments" do
          expect(Appointment.count).to eq(2)
        end

        it "returns the appointments" do
          expect(JSON.parse(last_response.body).map { _1["patient_name"] }).to include("John Doe", "Jane Doe")
        end
      end

      context "with a single appointment" do
        let(:params) do
          {appointment: {patient_name: "John Doe", start_time: "2019-01-01 09:00 AM UTC"}}
        end

        it "responds with 201" do
          expect(last_response).to be_created
        end

        it "creates the appointment" do
          expect(Appointment.count).to eq(1)
        end

        it "returns the appointment" do
          expect(JSON.parse(last_response.body).first.values).to include("John Doe")
        end
      end
    end

    context "with invalid params" do
      let(:params) do
        {}
      end

      it "responds with 400" do
        expect(last_response.status).to eq(400)
      end

      it "returns the error" do
        expect(JSON.parse(last_response.body)).to include("error")
      end

      it "does not create the appointment" do
        expect(Appointment.count).to eq(0)
      end
    end
  end

  describe "PUT /api/v1/doctors/:doctor_id/appointments/:appointment_id" do
    let(:doctor) { create(:doctor) }
    let(:appointment) { create(:appointment, doctor: doctor) }

    before do
      put "/api/v1/doctors/#{doctor.id}/appointments/#{appointment.id}", params, headers
    end

    context "with valid params" do
      let(:params) do
        {appointment: {patient_name: "John Doe", start_time: "2019-01-01 09:00 AM UTC"}}
      end

      it "responds with 200" do
        expect(last_response).to be_ok
      end

      it "updates the appointment" do
        expect(appointment.reload.patient_name).to eq("John Doe")
      end

      it "returns the appointment" do
        expect(JSON.parse(last_response.body).values).to include("John Doe")
      end
    end

    context "with invalid params" do
      let(:params) do
        {}
      end

      it "responds with 400" do
        expect(last_response.status).to eq(400)
      end

      it "returns the errors" do
        expect(JSON.parse(last_response.body)).to include("error" => "Appointment not found")
      end

      it "does not update the appointment" do
        expect(appointment.reload.patient_name).not_to eq("John Doe")
      end
    end
  end

  describe "DELETE /api/v1/doctors/:doctor_id/appointments/:appointment_id" do
    let(:doctor) { create(:doctor) }
    let(:appointment) { create(:appointment, doctor: doctor) }
    let(:appointment_id) { appointment.id }

    before do
      delete "/api/v1/doctors/#{doctor.id}/appointments/#{appointment_id}", nil, headers
    end

    it "responds with 204" do
      expect(last_response).to be_empty
    end

    it "deletes the appointment" do
      expect(Appointment.count).to eq(0)
    end

    context "when appointment not found" do
      let(:appointment_id) { appointment.id + 1 }

      it "responds with 400" do
        expect(last_response.status).to eq(400)
      end

      it "returns the error" do
        expect(JSON.parse(last_response.body)).to include("error" => "Appointment not found")
      end
    end
  end
end
