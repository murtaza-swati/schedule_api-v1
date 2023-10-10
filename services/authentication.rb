module Authentication
  class AuthError < StandardError; end

  def exchange_key
    organization = Organization.find_by(email: params[:email])
    return nil unless organization
    return nil unless organization.authenticate_api_key(params[:api_key])

    AuthToken.issue_token(organization_id: organization.id)
  end

  def current_organization
    @current_organization ||= Organization.find_by(id: token["organization_id"]) if authenticated?
  end

  def authenticated?
    self.token = request.headers["Authorization"]
  end

  private

  attr_reader :token

  def token=(token)
    @token = validate_token(token)
  end

  def validate_token(token)
    case token
    when /^Bearer /
      AuthToken.decode_token(token.gsub(/^Bearer /, ""))
    else
      raise AuthError, "Token must be a Bearer token" # TODO: add to locale
    end
  rescue JWT::DecodeError => e
    raise AuthError, "Invalid token " + e.message # TODO: add to locale
  end
end
