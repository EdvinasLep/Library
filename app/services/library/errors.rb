# frozen_string_literal: true

module Library
  class Error < StandardError; end
  class BookNotFoundError < Error; end
  class BookNotAvailableError < Error; end
  class BookNotBorrowedError < Error; end
  class InvalidBorrowDaysError < Error; end
end
