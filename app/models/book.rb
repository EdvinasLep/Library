# frozen_string_literal: true

require_relative "../../db/db"

class Book < ActiveRecord::Base
  has_one :borrowed_book
end
