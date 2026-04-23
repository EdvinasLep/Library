# frozen_string_literal: true

require_relative "../../../app/services/library/book_listing_service"

RSpec.describe Library::BookListingService do
  subject(:service) { described_class.new }

  describe "#list_available_books" do
    context 'when books are available and none are borrowed' do
      let!(:books) { create_list(:book, 5) }

      it "returns all books ordered by id" do
        expect(service.list_available_books).to match_array(books)
      end

      it "orders books by ascending id" do
        ids = service.list_available_books.pluck(:id)
        expect(ids).to eq(ids.sort)
      end
    end

    context "when book is borrowed" do
      let!(:books) { create_list(:book, 5) }

      before { create(:borrowed_book, book: books.first) }

      it "returns only unborrowed books" do
        expect(service.list_available_books).to_not include(books.first)
      end
    end

    context "when every book in the catalog is borrowed" do
      let!(:books) { create_list(:book, 3) }

      before { books.each { |b| create(:borrowed_book, book: b) } }

      it "returns an empty list" do
        expect(service.list_available_books.to_a).to be_empty
      end
    end

    context "when no books are available" do
      it "returns an empty list" do
        expect(service.list_available_books.to_a).to be_empty
      end
    end
  end
end
