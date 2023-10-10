require "bcrypt"

class Organization < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true
  validates :name, :api_key_digest, presence: true

  def api_key=(new_api_key)
    self.api_key_digest = BCrypt::Password.create(new_api_key)
  end

  def authenticate_api_key(test_api_key)
    BCrypt::Password.new(api_key_digest) == test_api_key
  end
end
