# frozen_string_literal: true

# test/serializers/invoice_serializer_test.rb
require 'test_helper'

class InvoicesSerializerTest < ActiveSupport::TestCase
  test 'serializes the correct attributes' do
    invoice = build(
      :invoice,
      invoice_number: 'INV-123',
      total: 1000.50,
      status: 'Vigente',
      active: true
    )

    serialized = InvoiceSerializer.new(invoice).serializable_hash
    data = serialized[:data][:attributes]

    assert_equal 'INV-123', data[:invoice_number]
    assert_equal 1000.50, data[:total]
    assert_equal Date.today, data[:invoice_date]
    assert_equal 'Vigente', data[:status]
    assert_equal true, data[:active]

    expected_keys = %i[invoice_number total invoice_date status active]
    assert_equal expected_keys.sort, data.keys.sort
  end
end
