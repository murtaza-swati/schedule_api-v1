require "jwt"

class AuthToken
  SECRET_KEY = ENV["SECRET_KEY"]
  ALGORITHM = "HS256"

  def self.issue_token(payload)
    JWT.encode(payload, SECRET_KEY, ALGORITHM)
  end

  def self.decode_token(token)
    JWT.decode(token, SECRET_KEY, true, {algorithm: ALGORITHM}).first
  end
end
