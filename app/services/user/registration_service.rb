# frozen_string_literal: true

require_relative "../../models/user"
require_relative "errors"

module Users
  class RegistrationService
    MIN_PASSWORD_LENGTH = 4

    def register(username:, password:)
      name = username.to_s.strip
      raise InvalidCredentialsError, "Username cannot be empty." if name.empty?
      raise InvalidPasswordError, "Password must be at least #{MIN_PASSWORD_LENGTH} characters." if password.to_s.length < MIN_PASSWORD_LENGTH
      raise UsernameTakenError, "Username '#{name}' is already taken." if User.exists?(username: name)

      User.create!(username: name, password: password)
    rescue ActiveRecord::RecordNotUnique
      raise UsernameTakenError, "Username '#{name}' is already taken."
    end
  end
end
