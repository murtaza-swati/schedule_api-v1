require "test_helper"

RSpec.describe ApiKeyService do
  subject { described_class.new }
  let(:organization) { create(:organization) }

  describe "#generate_api_key" do
    it "returns a 32 character string" do
      expect(subject.generate_api_key.length).to eq(64)
    end
  end

  describe "#rotate_api_key" do
    it "returns a 64 character string" do
      expect(subject.rotate_api_key(organization).length).to eq(64)
    end

    it "updates the organization's api_key" do
      expect { subject.rotate_api_key(organization) }.to change { organization.reload.api_key_digest }
    end
  end
end
