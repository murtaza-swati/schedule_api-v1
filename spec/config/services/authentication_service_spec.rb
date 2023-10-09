require "test_helper"
require 'jwt'

RSpec.describe AuthenticationService do
  let(:organization) { create(:organization) }
  let(:api_key) { organization.api_key }
  let(:token) { JWT.encode({organization_id: organization.id}, nil, 'none')}
  let(:headers) { {"HTTP_AUTHORIZATION" => "Bearer #{token}"} }

  describe "#exchange_key" do
    subject { described_class.new.exchange_key(params) }

    context "when organization found" do
      let(:params) { { api_key: api_key } }

      it "returns JWT token" do
        expect(subject).to eq(token)
      end
    end

    context "when not authorized" do
      let(:params) { { api_key: "invalid" } }

      it "returns nil" do
        expect(subject).to be_nil
      end
    end
  end
end
