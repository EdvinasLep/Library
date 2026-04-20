# frozen_string_literal: true

require_relative "../../models/user"
require_relative "errors"

module Users
  class AuthService
    def login(username:, password:)
      name = username.to_s.strip
      user = User.find_by(username: name)
      raise InvalidCredentialsError, "Invalid username or password." if user.nil?
      raise InvalidCredentialsError, "Invalid username or password." unless user.authenticate(password)

      user
    end
  end
end
