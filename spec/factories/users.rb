# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username
    password { "password" }
  end
end
