# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    id { generate(:book_id) }
    book_name
    author { generate(:author_name) }
    release_year { 2000 }
  end
end
