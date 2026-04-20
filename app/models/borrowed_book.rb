# frozen_string_literal: true

require_relative "../../db/db"

class BorrowedBook < ActiveRecord::Base
  belongs_to :user
  belongs_to :book
end
