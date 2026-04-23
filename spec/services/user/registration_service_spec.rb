# frozen_string_literal: true

require_relative "../../../app/services/user/registration_service"

RSpec.describe Users::RegistrationService do
  subject(:service) { described_class.new }

  describe "#register" do
    context "with valid credentials" do
      it "creates and returns user" do
        user = service.register(username: "john", password: "doe123")

        expect(user).to be_a(User)
        expect(user).to be_persisted
      end

      it "strips surrounding whitespace from the username" do
        user = service.register(username: "john", password: "doe123")

        expect(user.username).to eq("john")
      end
    end

    context "when the username is nil" do
      it "raises InvalidCredentialsError" do
        expect {
          service.register(username: nil, password: "secret123")
        }.to raise_error(Users::InvalidCredentialsError, "Username cannot be empty.")
      end
    end

    context "when the password is shorter than the minimum" do
      it "raises InvalidPasswordError" do
        expect {
          service.register(username: "john", password: "doe")
        }.to raise_error(
          Users::InvalidPasswordError,
          "Password must be at least #{Users::RegistrationService::MIN_PASSWORD_LENGTH} characters."
        )
      end
    end

    context "when the username is already taken" do
      let!(:existing_user) { create(:user) }

      it "raises UsernameTakenError" do
        expect {
          service.register(username: existing_user.username, password: "doe123")
        }.to raise_error(Users::UsernameTakenError, "Username '#{existing_user.username}' is already taken.")
      end
    end

    context "when create! raises RecordNotUnique" do
      before do
        allow(User).to receive(:exists?).and_return(false)
        allow(User).to receive(:create!).and_raise(ActiveRecord::RecordNotUnique.new("duplicate"))
      end

      it "maps the error to UsernameTakenError" do
        expect {
          service.register(username: "john", password: "doe123")
        }.to raise_error(Users::UsernameTakenError, "Username 'john' is already taken.")
      end
    end
  end
end
