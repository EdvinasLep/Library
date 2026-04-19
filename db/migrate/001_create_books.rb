# frozen_string_literal: true

class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books, id: false do |t|
      t.primary_key :id
      t.string  :book_name, null: false
      t.string  :author, null: false
      t.integer :release_year, null: false
    end
  end
end