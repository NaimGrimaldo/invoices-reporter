# frozen_string_literal: true

class ReportMailer < ApplicationMailer
  default from: ENV.fetch('SMTP_USER_NAME', nil)

  def daily_sales_report(top_sales)
    @top_sales = top_sales
    mail(to: ENV.fetch('EMAIL_TO_SEND_DAILY_REPORT', nil), subject: 'Daily sales report')
  end
end
