module Authentication
  attr_accessor :errors

  def exchange_key
    organization = Organization.find_by(email: params[:email])
    error = {error: "Incorrect email or api_key"}
    return error unless organization&.authenticate_api_key(params[:api_key])

    {token: AuthToken.issue_token(organization_id: organization.id)}
  end

  def current_organization
    @current_organization ||= Organization.find_by(id: token["organization_id"]) if authenticated?
  end

  def authenticated?
    self.errors = []
    validate_token(request.env["Authorization"])
    errors.empty?
  end

  private

  attr_accessor :token

  def validate_token(token)
    case token
    when /^Bearer /
      self.token = AuthToken.decode_token(token.gsub(/^Bearer /, ""))
    else
      errors << ["Token must be a Bearer token"] # TODO: add to locale
    end
  rescue JWT::DecodeError => e
    errors << "Invalid token " + e.message # TODO: add to locale
  end
end
