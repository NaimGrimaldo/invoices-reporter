# frozen_string_literal: true

class DailySalesReportMailJob < ApplicationJob
  queue_as :default

  def perform
    top_sales = TopSalesPerDay.all(limit: 10)
    Rails.logger.info "Daily sales report sent at: #{Time.current}"
    ReportMailer.daily_sales_report(top_sales).deliver_now
  end
end
