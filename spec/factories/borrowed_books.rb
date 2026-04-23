# frozen_string_literal: true

require "date"

FactoryBot.define do
  factory :borrowed_book do
    user
    book
    borrowed_on { Date.today }
    borrowed_for { 7 }

    trait :due_today do
      borrowed_on { Date.today - 7 }
      borrowed_for { 7 }
    end

    trait :overdue do
      borrowed_on { Date.today - 20 }
      borrowed_for { 7 }
    end

    trait :not_yet_due do
      borrowed_on { Date.today - 1 }
      borrowed_for { 7 }
    end
  end
end
