# frozen_string_literal: true

require "active_record"

unless ActiveRecord::Base.connected?
  ActiveRecord::Base.establish_connection(
    adapter: "sqlite3",
    database: "db/library.sqlite3"
  )
end