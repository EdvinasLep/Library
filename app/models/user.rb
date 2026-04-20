# frozen_string_literal: true

require "bcrypt"
require_relative "../../db/db"

class User < ActiveRecord::Base
  has_secure_password

  has_many :borrowed_books, dependent: :destroy

  validates :username, presence: true, uniqueness: true
end
