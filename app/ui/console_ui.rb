# frozen_string_literal: true

class ConsoleUi
  def ask(prompt)
    puts prompt
    gets.to_s.strip
  end

  def welcome
    puts "Welcome to the Library System!"
  end

  def goodbye
    puts "Goodbye!"
  end

  def show_auth_menu
    puts
    puts "1. Login"
    puts "2. Register"
    puts "3. Exit"
  end

  def login_success(user)
    puts "Welcome back, #{user.username}!"
  end

  def register_success(user)
    puts "Account created. Welcome, #{user.username}!"
  end

  def invalid_auth_choice
    puts "Invalid option. Please choose 1, 2, or 3."
  end

  def invalid_menu_choice
    puts "Invalid option. Please choose between 1 and 4."
  end

  def borrow_success(book)
    puts "Successfully borrowed '#{book.book_name}'."
  end

  def return_success(book)
    puts "Thank you for returning '#{book.book_name}'."
  end

  def error(message)
    puts "Error: #{message}"
  end

  def show_menu
    puts
    puts "1. List available books"
    puts "2. Borrow a book"
    puts "3. Return a book"
    puts "4. Exit"
  end

  def show_books(books)
    puts

    if books.empty?
      puts "No books are currently available."
      return
    end

    books.each do |book|
      puts "#{book.id} #{book.book_name} #{book.author} #{book.release_year}"
    end
  end

  def show_borrowed_books(borrowed_books)
    puts
    borrowed_books.each do |borrowed_book|
      puts "#{borrowed_book.book.id} #{borrowed_book.book.book_name} #{borrowed_book.book.author} #{borrowed_book.book.release_year} Borrowed on: #{borrowed_book.borrowed_on} Borrowed for: #{borrowed_book.borrowed_for} days"
    end
  end
end
