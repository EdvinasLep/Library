# frozen_string_literal: true

require "csv"

class BookNotAvailableError < StandardError; end
class BookNotBorrowedError < StandardError; end
class BookNotFoundError < StandardError; end

class LibraryService
  def initialize(books_csv_path:, users_file_path:, borrowed_file_path:)
    @books_csv_path = books_csv_path
    @users_file_path = users_file_path
    @borrowed_file_path = borrowed_file_path
    ensure_file!(@users_file_path)
    ensure_file!(@borrowed_file_path)
  end

  def user_exists?(username)
    read_usernames.include?(normalize(username))
  end

  def register_user(username)
    name = normalize(username)
    return if name.empty? || user_exists?(name)

    File.open(@users_file_path, "a") { |f| f.puts(name) }
  end

  def list_available_books
    borrowed_ids = borrowed_records.map { |entry| entry[:book_id] }
    all_books.reject { |book| borrowed_ids.include?(book[:id]) }
  end

  def borrow_book(book_id:, username:)
    id = book_id.to_i
    book = find_book(id)
    raise BookNotFoundError, "Book #{id} does not exist." if book.nil?
    raise BookNotAvailableError, "Book #{id} is already borrowed." if book_borrowed?(id)

    File.open(@borrowed_file_path, "a") { |f| f.puts("#{id},#{normalize(username)}") }
    book
  end

  def return_book(book_id:, username:)
    id = book_id.to_i
    book = find_book(id)
    raise BookNotFoundError, "Book #{id} does not exist." if book.nil?

    name = normalize(username)
    records = borrowed_records
    unless records.any? { |entry| entry[:book_id] == id && entry[:username] == name }
      raise BookNotBorrowedError, "Book #{id} is not borrowed by #{name}."
    end

    remaining = records.reject { |entry| entry[:book_id] == id && entry[:username] == name }
    content = remaining.map { |entry| "#{entry[:book_id]},#{entry[:username]}" }.join("\n")
    content += "\n" unless content.empty?
    File.write(@borrowed_file_path, content)
    book
  end

  private

  def all_books
    CSV.read(@books_csv_path, headers: true).map do |row|
      {
        id: row["Book ID"].to_i,
        name: row["Book Name"].to_s.strip,
        author: row["Author"].to_s.strip,
        release_year: row["Release Year"].to_i
      }
    end
  end

  def find_book(id)
    all_books.find { |book| book[:id] == id }
  end

  def book_borrowed?(id)
    borrowed_records.any? { |entry| entry[:book_id] == id }
  end

  def borrowed_records
    File.readlines(@borrowed_file_path, chomp: true).filter_map do |line|
      parts = line.to_s.split(",", 2).map(&:strip)
      next if parts.length != 2 || parts[0].empty? || parts[1].empty?

      { book_id: parts[0].to_i, username: parts[1] }
    end
  end

  def read_usernames
    File.readlines(@users_file_path, chomp: true).map { |line| normalize(line) }.reject(&:empty?)
  end

  def normalize(value)
    value.to_s.strip
  end

  def ensure_file!(path)
    File.write(path, "") unless File.exist?(path)
  end
end
