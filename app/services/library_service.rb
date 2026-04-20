# frozen_string_literal: true

require "date"
require_relative "../models/user"
require_relative "../models/book"
require_relative "../models/borrowed_book"

class BookNotAvailableError < StandardError; end
class BookNotBorrowedError < StandardError; end
class BookNotFoundError < StandardError; end
class UsernameTakenError < StandardError; end
class InvalidCredentialsError < StandardError; end
class InvalidPasswordError < StandardError; end

class LibraryService
  DEFAULT_BORROW_PERIOD_DAYS = 14
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

  def login(username:, password:)
    name = username.to_s.strip
    user = User.find_by(username: name)
    raise InvalidCredentialsError, "Invalid username or password." if user.nil?
    raise InvalidCredentialsError, "Invalid username or password." unless user.authenticate(password)

    user
  end

  def list_available_books
    Book
      .left_joins(:borrowed_book)
      .where(borrowed_books: { id: nil })
      .order(:id)
  end

  def borrow_book(book_id:, user:)
    id = book_id.to_i
    book = Book.find_by(id: id)
    raise BookNotFoundError, "Book #{id} does not exist." if book.nil?
    raise BookNotAvailableError, "Book #{id} is already borrowed." if BorrowedBook.exists?(book_id: id)

    BorrowedBook.create!(
      book_id: id,
      user_id: user.id,
      borrowed_on: Date.today,
      borrowed_for: DEFAULT_BORROW_PERIOD_DAYS
    )
    book
  rescue ActiveRecord::RecordNotUnique
    raise BookNotAvailableError, "Book #{id} is already borrowed."
  end

  def return_book(book_id:, user:)
    id = book_id.to_i
    book = Book.find_by(id: id)
    raise BookNotFoundError, "Book #{id} does not exist." if book.nil?

    record = BorrowedBook.find_by(book_id: id, user_id: user.id)
    raise BookNotBorrowedError, "Book #{id} is not borrowed by #{user.username}." if record.nil?

    record.destroy!
    book
  end
end
