# frozen_string_literal: true

require_relative "../../../app/services/library/return_service"

RSpec.describe Library::ReturnService do
  subject(:service) { described_class.new }

  let(:user) { create(:user) }
  let(:book) { create(:book) }

  describe "#return_book" do
    context "when the user has borrowed the book on time" do
      let!(:borrowed) { create(:borrowed_book, user: user, book: book) }

      it "returns a ReturnOutcome and deletes the borrowed_book record" do
        outcome = service.return_book(book_id: book.id, user: user)

        expect(outcome).to be_a(Library::ReturnOutcome)
        expect(outcome.book).to eq(book)
        expect(outcome.days_late).to eq(0)
        expect(outcome.late_fee).to eq(0.0)
        expect(BorrowedBook.exists?(borrowed.id)).to be(false)
      end
    end

    context "when the borrowed book is overdue" do
      before { create(:borrowed_book, :overdue, user: user, book: book) }

      it "shows late days and fee" do
        outcome = service.return_book(book_id: book.id, user: user)

        expect(outcome.days_late).to eq(13)
        expect(outcome.late_fee).to eq(13 * Library::LateFeeCalculator::FEE_PER_LATE_DAY)
      end
    end

    context "when the book does not exist" do
      it "raises BookNotFoundError" do
        expect {
          service.return_book(book_id: 9999, user: user)
        }.to raise_error(Library::BookNotFoundError, "Book 9999 does not exist.")
      end
    end

    context "when another user borrowed the book" do
      let(:other_user) { create(:user, username: "someone_else") }

      before { create(:borrowed_book, user: other_user, book: book) }

      it "raises BookNotBorrowedError" do
        expect {
          service.return_book(book_id: book.id, user: user)
        }.to raise_error(Library::BookNotBorrowedError, /is not borrowed by #{user.username}/)
      end
    end

    context "when the book exists but is not borrowed" do
      it "raises BookNotBorrowedError" do
        expect {
          service.return_book(book_id: book.id, user: user)
        }.to raise_error(Library::BookNotBorrowedError)
      end
    end
  end

  describe "#borrowed_books" do
    context "when the user has borrowed books" do
      let(:other_user) { create(:user, username: "someone_else") }
      let!(:user_book) { create(:borrowed_book, user: user, book: book) }

      before { create(:borrowed_book, user: other_user, book: create(:book)) }

      it "returns only that user's borrowed book" do
        expect(service.borrowed_books(user: user).to_a).to eq([user_book])
      end
    end

    context "when the user has no borrowed books" do
      it "raises NoBorrowedBooksError" do
        expect {
          service.borrowed_books(user: user)
        }.to raise_error(Library::NoBorrowedBooksError, "You have no books borrowed.")
      end
    end
  end
end
