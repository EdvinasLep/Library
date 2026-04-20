# frozen_string_literal: true

require_relative "db/db"
require_relative "app/models/book"
require_relative "app/models/user"
require_relative "app/models/borrowed_book"
require_relative "app/services/user/auth_service"
require_relative "app/services/user/registration_service"
require_relative "app/services/library/book_listing_service"
require_relative "app/services/library/borrow_service"
require_relative "app/services/library/return_service"
require_relative "app/app"

App.new(
  auth_service: Users::AuthService.new,
  registration_service: Users::RegistrationService.new,
  book_listing_service: Library::BookListingService.new,
  borrow_service: Library::BorrowService.new,
  return_service: Library::ReturnService.new,
  console_ui: ConsoleUi.new
).run
