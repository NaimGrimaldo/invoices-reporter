# frozen_string_literal: true

require 'test_helper'

class TopSalesPerDayTest < ActiveSupport::TestCase
  test 'returns sales grouped by day with totals' do
    fake_result = [
      { 'sale_date' => Date.yesterday.to_s, 'total' => 300.0, 'invoices_count' => 2 }
    ]

    with_fake_exec_query(fake_result) do
      results = TopSalesPerDay.all(limit: 5)
      invoice = results.first

      assert_equal 1, results.size
      assert_equal '300.0', invoice['total'].to_s
      assert_equal 2, invoice['invoices_count']
      assert_equal Date.yesterday.to_s, invoice['sale_date']
    end
  end
end
