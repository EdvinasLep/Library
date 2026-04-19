# frozen_string_literal: true

require "csv"
require_relative "../../app/models/book"

csv_path = File.expand_path("../books.csv", __dir__)
created_count = 0

CSV.foreach(csv_path, headers: true) do |row|
  Book.create!(
    id: row["Book ID"].to_i,
    book_name: row["Book Name"],
    author: row["Author"],
    release_year: row["Release Year"].to_i
  )
end