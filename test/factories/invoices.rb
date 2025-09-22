# frozen_string_literal: true

FactoryBot.define do
  factory :invoice do
    invoice_number { 'C30481' }
    total { rand(1..1232) }
    invoice_date { Date.today }
    status { 'Vigente' }
    active { false }
  end
end
