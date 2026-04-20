# frozen_string_literal: true

require "date"
require_relative "../../models/book"
require_relative "../../models/borrowed_book"
require_relative "errors"

module Library
  class BorrowService
    DEFAULT_BORROW_PERIOD_DAYS = 14

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
  end
end
