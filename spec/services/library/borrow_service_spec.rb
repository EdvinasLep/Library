# frozen_string_literal: true

require_relative "../../../app/services/library/borrow_service"

RSpec.describe Library::BorrowService do
  subject(:service) { described_class.new }

  describe "#borrow_book" do
    context "when the book is available" do
      let(:user) { create(:user) }
      let(:book) { create(:book) }

      it "creates a borrowed_book record and returns the book" do
        result = service.borrow_book(book_id: book.id, user: user, days_borrowed: 7)

        expect(result).to eq(book)
      end

      context "when borrowing for the minimum period" do
        it "succeeds" do
          expect {
            service.borrow_book(book_id: book.id, user: user, days_borrowed: 1)
          }.not_to raise_error
        end
      end

      context "when borrowing for the maximum period" do
        it "succeeds" do
          expect {
            service.borrow_book(book_id: book.id, user: user, days_borrowed: 14)
          }.not_to raise_error
        end
      end
    end

    context "when the borrow period is invalid" do
      let(:user) { create(:user) }
      let(:book) { create(:book) }

      context "when days is zero" do
        it "raises InvalidBorrowDaysError" do
          expect {
            service.borrow_book(book_id: book.id, user: user, days_borrowed: 0)
          }.to raise_error(Library::InvalidBorrowDaysError, /between 1 and 14 days/)
        end
      end

      context "when days exceeds the maximum" do
        it "raises InvalidBorrowDaysError" do
          expect {
            service.borrow_book(book_id: book.id, user: user, days_borrowed: 15)
          }.to raise_error(Library::InvalidBorrowDaysError)
        end
      end
    end

    context "when the book does not exist" do
      let(:user) { create(:user) }

      it "raises BookNotFoundError" do
        expect {
          service.borrow_book(book_id: 9999, user: user, days_borrowed: 5)
        }.to raise_error(Library::BookNotFoundError, "Book 9999 does not exist.")
      end
    end

    context "when the book is already borrowed" do
      let(:user) { create(:user) }
      let(:book) { create(:book) }

      before { create(:borrowed_book, book: book) }

      it "raises BookNotAvailableError" do
        expect {
          service.borrow_book(book_id: book.id, user: user, days_borrowed: 5)
        }.to raise_error(Library::BookNotAvailableError, "Book #{book.id} is already borrowed.")
      end
    end
  end
end
