# frozen_string_literal: true

require_relative "../../../app/services/library/late_fee_calculator"

RSpec.describe Library::LateFeeCalculator do
  let(:user) { create(:user) }
  let(:book) { create(:book) }

  describe ".due_on" do
    context "with a fixed borrow window" do
      let!(:record) do
        create(
          :borrowed_book,
          user: user,
          book: book,
          borrowed_on: Date.new(2026, 1, 1),
          borrowed_for: 10
        )
      end

      it "adds borrowed_for days to borrowed_on" do
        expect(described_class.due_on(record)).to eq(Date.new(2026, 1, 11))
      end
    end
  end

  describe ".late_days" do
    context "with a fixed borrow window" do
      let!(:record) do
        create(
          :borrowed_book,
          user: user,
          book: book,
          borrowed_on: Date.new(2026, 1, 1),
          borrowed_for: 10
        )
      end

      context "when as_of is before the due date" do
        it "returns 0" do
          expect(described_class.late_days(record, as_of: Date.new(2026, 1, 5))).to eq(0)
        end
      end

      context "when as_of is on the due date" do
        it "returns 0" do
          expect(described_class.late_days(record, as_of: Date.new(2026, 1, 11))).to eq(0)
        end
      end

      context "when as_of is after the due date" do
        it "returns the number of days overdue" do
          expect(described_class.late_days(record, as_of: Date.new(2026, 1, 16))).to eq(5)
        end
      end
    end

    context "when as_of is omitted" do
      let!(:record) { create(:borrowed_book, :overdue, user: user, book: book) }

      it "uses Date.today" do
        expect(described_class.late_days(record)).to eq(13)
      end
    end
  end

  describe ".fee" do
    context "with a fixed borrow window" do
      let!(:record) do
        create(
          :borrowed_book,
          user: user,
          book: book,
          borrowed_on: Date.new(2026, 1, 1),
          borrowed_for: 10
        )
      end

      context "when not overdue" do
        it "returns 0" do
          expect(described_class.fee(record, as_of: Date.new(2026, 1, 5))).to eq(0)
        end
      end

      context "when overdue" do
        it "returns late_days * FEE_PER_LATE_DAY" do
          expect(described_class.fee(record, as_of: Date.new(2026, 1, 15))).to eq(4 * described_class::FEE_PER_LATE_DAY)
        end
      end
    end
  end
end
