# frozen_string_literal: true

require_relative "app/app"

root_dir = __dir__

library_service = LibraryService.new(
  books_csv_path: File.join(root_dir, "db", "books.csv"),
  users_file_path: File.join(root_dir, "users.db"),
  borrowed_file_path: File.join(root_dir, "borrowed_books.db")
)
console_ui = ConsoleUi.new

App.new(library_service: library_service, console_ui: console_ui).run
