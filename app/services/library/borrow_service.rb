# frozen_string_literal: true

require "date"
require_relative "../../models/book"
require_relative "../../models/borrowed_book"
require_relative "errors"

module Library
  class BorrowService
    MIN_BORROW_PERIOD_DAYS = 1
    MAX_BORROW_PERIOD_DAYS = 14

    def borrow_book(book_id:, user:, days_borrowed:)
      days = days_borrowed.to_i
      raise InvalidBorrowDaysError, "Borrowing period is invalid. It must be between #{MIN_BORROW_PERIOD_DAYS} and #{MAX_BORROW_PERIOD_DAYS} days." if days < MIN_BORROW_PERIOD_DAYS || days > MAX_BORROW_PERIOD_DAYS

      id = book_id.to_i
      book = Book.find_by(id: id)
      raise BookNotFoundError, "Book #{id} does not exist." if book.nil?
      raise BookNotAvailableError, "Book #{id} is already borrowed." if BorrowedBook.exists?(book_id: id)

      BorrowedBook.create!(
        book_id: id,
        user_id: user.id,
        borrowed_on: Date.today,
        borrowed_for: days
      )
      book
    rescue ActiveRecord::RecordNotUnique
      raise BookNotAvailableError, "Book #{id} is already borrowed."
    end
  end
end
