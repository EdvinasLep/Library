# frozen_string_literal: true

require_relative "db/db"
require_relative "app/models/book"
require_relative "app/models/user"
require_relative "app/models/borrowed_book"
require_relative "app/app"

App.new(
  library_service: LibraryService.new,
  console_ui: ConsoleUi.new
).run
