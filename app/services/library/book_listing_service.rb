# frozen_string_literal: true

require_relative "../../models/book"
require_relative "../../models/borrowed_book"
require_relative "errors"

module Library
  class BookListingService
    def list_available_books
      Book
        .left_joins(:borrowed_book)
        .where(borrowed_books: { id: nil })
        .order(:id)
    end
  end
end
