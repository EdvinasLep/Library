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

  def welcome_back(username)
    puts "Welcome back, #{username}!"
  end

  def account_created(username)
    puts "Account created. Welcome, #{username}!"
  end

  def invalid_menu_choice
    puts "Invalid option. Please choose between 1 and 4."
  end

  def borrow_success(book)
    puts "Successfully borrowed '#{book[:name]}'."
  end

  def return_success(book)
    puts "Thank you for returning '#{book[:name]}'."
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
    if books.empty?
      puts "No books are currently available."
      return
    end

    books.each do |book|
      puts "#{book[:id]} #{book[:name]} #{book[:author]} #{book[:release_year]}"
    end
  end
end
