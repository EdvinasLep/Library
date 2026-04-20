# frozen_string_literal: true

require "date"
require_relative "../../models/book"
require_relative "../../models/borrowed_book"
require_relative "late_fee_calculator"
require_relative "errors"

module Library
  ReturnOutcome = Struct.new(:book, :days_late, :late_fee, keyword_init: true)

  class ReturnService
    def return_book(book_id:, user:)
      id = book_id.to_i
      book = Book.find_by(id: id)
      raise BookNotFoundError, "Book #{id} does not exist." if book.nil?

      record = BorrowedBook.find_by(book_id: id, user_id: user.id)
      raise BookNotBorrowedError, "Book #{id} is not borrowed by #{user.username}." if record.nil?

      days_late = LateFeeCalculator.late_days(record)
      late_fee = LateFeeCalculator.fee(record)
      record.destroy!

      ReturnOutcome.new(book: book, days_late: days_late, late_fee: late_fee)
    end

    def borrowed_books(user:)
      borrowed_books = BorrowedBook.where(user_id: user.id).includes(:book)
      raise NoBorrowedBooksError, "You have no books borrowed." if borrowed_books.empty?

      borrowed_books
    end
  end
end
