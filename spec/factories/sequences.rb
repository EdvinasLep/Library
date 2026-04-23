# frozen_string_literal: true

FactoryBot.define do
  sequence(:username) { |n| "user#{n}" }
  sequence(:book_id, 1)
  sequence(:book_name) { |n| "Book Title #{n}" }
  sequence(:author_name) { |n| "Author #{n}" }
end
