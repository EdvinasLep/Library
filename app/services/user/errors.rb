# frozen_string_literal: true

module Users
  class Error < StandardError; end
  class InvalidCredentialsError < Error; end
  class UsernameTakenError < Error; end
  class InvalidPasswordError < Error; end
end
