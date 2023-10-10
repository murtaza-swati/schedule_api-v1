require "test_helper"

RSpec.describe AuthToken do
  let(:payload) { {user_id: 1} }
  let(:token) { described_class.issue_token(payload) }

  describe ".issue_token" do
    it "returns a JWT token" do
      expect(token).to be_a(String)
    end
  end

  describe ".decode_token" do
    it "decodes a JWT token" do
      decoded_payload = described_class.decode_token(token)
      expect(decoded_payload).to eq(payload.stringify_keys)
    end
  end
end
