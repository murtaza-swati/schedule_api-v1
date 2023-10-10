class ApiKeyService
  def generate_api_key
    SecureRandom.hex(32)
  end

  def rotate_api_key(organization)
    api_key = generate_api_key
    organization.api_key = api_key
    organization.save!
    api_key
  end

  private

  attr_accessor :organization
end
