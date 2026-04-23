# frozen_string_literal: true

require_relative "../../../app/services/user/auth_service"

RSpec.describe Users::AuthService do
  subject(:service) { described_class.new }

  describe '#login' do
    context 'when the user exists' do
      let!(:user) { create(:user) }

      it "returns the user when credentials are valid" do
        expect(service.login(username: user.username, password: user.password)).to eq(user)
      end

      it "trims whitespace from the username before lookup" do
        expect(service.login(username: "  #{user.username} ", password: user.password)).to eq(user)
      end

      context "when the password is wrong" do
        it "raises InvalidCredentialsError" do
          expect {
            service.login(username: user.username, password: "password!")
          }.to raise_error(Users::InvalidCredentialsError, "Invalid username or password.")
        end
      end
    end

    context "when the username does not exist" do
      it "raises InvalidCredentialsError" do
        expect {
          service.login(username: "user", password: "password")
        }.to raise_error(Users::InvalidCredentialsError, "Invalid username or password.")
      end
    end

    context "when the username is nil" do
      it "raises InvalidCredentialsError" do
        expect {
          service.login(username: nil, password: "password")
        }.to raise_error(Users::InvalidCredentialsError)
      end
    end
  end
end
