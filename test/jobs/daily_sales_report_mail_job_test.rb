# frozen_string_literal: true

require 'test_helper'

class DailySalesReportMailJobTest < ActiveJob::TestCase
  test 'executes and sends email' do
    sales = [{ 'sale_date' => Date.yesterday.to_s, 'total' => 100, 'invoices_count' => 1 }]

    TopSalesPerDay.stub :all, sales do
      assert_difference 'Delayed::Job.count', +1 do
        Delayed::Job.enqueue DailySalesReportMailJob.new
      end
    end
  end
end
