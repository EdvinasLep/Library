# frozen_string_literal: true

require "date"

module Library
  class LateFeeCalculator
    FEE_PER_LATE_DAY = 2.50

    def self.due_on(borrowed_book)
      borrowed_book.borrowed_on + borrowed_book.borrowed_for
    end

    def self.late_days(borrowed_book, as_of: Date.today)
      due = due_on(borrowed_book)
      as_of > due ? (as_of - due).to_i : 0
    end

    def self.fee(borrowed_book, as_of: Date.today)
      late_days(borrowed_book, as_of: as_of) * FEE_PER_LATE_DAY
    end
  end
end
