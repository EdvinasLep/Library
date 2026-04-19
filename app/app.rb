# frozen_string_literal: true

require_relative "services/library_service"
require_relative "ui/console_ui"

class App
  def initialize(library_service:, console_ui:)
    @library_service = library_service
    @console_ui = console_ui
    @current_user = nil
  end

  def run
    @console_ui.welcome
    return unless login_flow

    menu_loop
    @console_ui.goodbye
  end

  private

  def login_flow
    username = @console_ui.ask("Enter your username:")

    if @library_service.user_exists?(username)
      @current_user = username.strip
      @console_ui.welcome_back(@current_user)
      return true
    end

    answer = @console_ui.ask("User '#{username}' does not exist. Create an account? (y/n):")
    unless answer.downcase == "y"
      @console_ui.goodbye
      return false
    end

    @library_service.register_user(username)
    @current_user = username.strip
    @console_ui.account_created(@current_user)
    true
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
    @console_ui.show_books(@library_service.list_available_books)
  end

  def borrow_book
    book_id = @console_ui.ask("Enter the book ID to borrow:")
    book = @library_service.borrow_book(book_id: book_id, username: @current_user)
    @console_ui.borrow_success(book)
  rescue BookNotAvailableError, BookNotFoundError => e
    @console_ui.error(e.message)
  end

  def return_book
    book_id = @console_ui.ask("Enter the book ID to return:")
    book = @library_service.return_book(book_id: book_id, username: @current_user)
    @console_ui.return_success(book)
  rescue BookNotBorrowedError, BookNotFoundError => e
    @console_ui.error(e.message)
  end
end
