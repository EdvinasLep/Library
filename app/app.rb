# frozen_string_literal: true

require_relative "services/user/auth_service"
require_relative "services/user/registration_service"
require_relative "services/library/book_listing_service"
require_relative "services/library/borrow_service"
require_relative "services/library/return_service"
require_relative "ui/console_ui"

class App
  def initialize(auth_service:, registration_service:,
                 book_listing_service:, borrow_service:, return_service:,
                 console_ui:)
    @auth_service = auth_service
    @registration_service = registration_service
    @book_listing_service = book_listing_service
    @borrow_service = borrow_service
    @return_service = return_service
    @console_ui = console_ui
    @current_user = nil
  end

  def run
    @console_ui.welcome
    return unless auth_menu

    menu_loop
    @console_ui.goodbye
  end

  private

  def auth_menu
    loop do
      @console_ui.show_auth_menu
      choice = @console_ui.ask("Choose an option (1-3):")

      case choice
      when "1"
        return true if login
      when "2"
        return true if register
      when "3"
        return false
      else
        @console_ui.invalid_auth_choice
      end
    end
  end

  def login
    username = @console_ui.ask("Enter your username:")
    password = @console_ui.ask("Enter your password:")
    @current_user = @auth_service.login(username: username, password: password)
    @console_ui.login_success(@current_user)
    true
  rescue Users::InvalidCredentialsError => e
    @console_ui.error(e.message)
    false
  end

  def register
    username = @console_ui.ask("Choose a username:")
    password = @console_ui.ask("Choose a password:")
    @current_user = @registration_service.register(username: username, password: password)
    @console_ui.register_success(@current_user)
    true
  rescue Users::UsernameTakenError, Users::InvalidCredentialsError, Users::InvalidPasswordError => e
    @console_ui.error(e.message)
    false
  end

  def menu_loop
    loop do
      @console_ui.show_menu
      choice = @console_ui.ask("Choose an option (1-4):")

      case choice
      when "1" then list_books
      when "2" then borrow_book
      when "3" then return_book
      when "4" then break
      else @console_ui.invalid_menu_choice
      end
    end
  end

  def list_books
    @console_ui.show_books(@book_listing_service.list_available_books)
  end

  def borrow_book
    book_id = @console_ui.ask("Enter the book ID to borrow:")
    book = @borrow_service.borrow_book(book_id: book_id, user: @current_user)
    @console_ui.borrow_success(book)
  rescue Library::BookNotAvailableError, Library::BookNotFoundError => e
    @console_ui.error(e.message)
  end

  def return_book
    book_id = @console_ui.ask("Enter the book ID to return:")
    book = @return_service.return_book(book_id: book_id, user: @current_user)
    @console_ui.return_success(book)
  rescue Library::BookNotBorrowedError, Library::BookNotFoundError => e
    @console_ui.error(e.message)
  end
end
