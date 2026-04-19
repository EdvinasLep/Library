# frozen_string_literal: true

class CreateBorrowedBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :borrowed_books do |t|
      t.integer  :book_id, null: false
      t.integer  :user_id, null: false
      t.date     :borrowed_on, null: false
      t.integer  :borrowed_for, null: false
    end
    add_index :borrowed_books, :book_id, unique: true
    add_index :borrowed_books, :user_id
  end
end