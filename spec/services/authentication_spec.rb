require "test_helper"

RSpec.describe Authentication do
  let(:described_module) do
    Class.new do
      attr_accessor :params, :request
      def initialize(params: {}, request: {})
        @params = params
        @request = request
      end
      include Authentication
    end.new(params: params, request: OpenStruct.new(env: headers))
  end

  let(:organization) { create(:organization, api_key: api_key) }
  let(:api_key) { ApiKeyService.new.generate_api_key }
  let(:token) { AuthToken.issue_token({organization_id: organization.id}) }
  let(:headers) { {"Authorization" => "Bearer #{token}"} }

  describe "#exchange_key" do
    subject { described_module.exchange_key }

    context "when organization found" do
      let(:params) { {api_key: api_key, email: organization.email} }

      it "returns JWT token" do
        expect(subject).to eq({token: token})
      end
    end

    context "when api key is invalid" do
      let(:params) { {api_key: "invalid"} }

      it "returns nil" do
        expect(subject).to eq({error: "Incorrect email or api_key"})
      end
    end

    context "when organization not found" do
      let(:params) { {api_key: api_key, email: "invalid"} }

      it "returns nil" do
        expect(subject).to eq({error: "Incorrect email or api_key"})
      end
    end
  end

  describe "#current_organization" do
    subject { described_module.current_organization }
    let(:params) { {} }

    context "when token is valid" do
      it "returns organization" do
        expect(subject).to eq(organization)
      end
    end

    context "when token is invalid" do
      let(:token) { "invalid" }

      it "returns nil" do
        expect(subject).to be_nil
      end
    end
  end
end
