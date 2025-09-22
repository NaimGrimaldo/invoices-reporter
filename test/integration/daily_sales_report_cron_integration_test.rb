# frozen_string_literal: true

require 'test_helper'

class DailyReportCronIntegrationTest < ActiveJob::TestCase
  include ActiveJob::TestHelper

  setup do
    # Limpiamos la cola y mails antes de cada tes
    ActionMailer::Base.deliveries.clear

    # Stub para TopSalesPerDay para no depender de la DB real
    @fake_sales = [
      { 'sale_date' => Date.yesterday.to_s, 'total' => 100.0, 'invoices_count' => 1 }
    ]
    unless Delayed::Job.where('handler LIKE ?', '%DailySalesReportMailJob%').exists?
      Delayed::Job.enqueue(DailySalesReportMailJob.new, cron: '0 7 * * *')
    end
    Rails.application.config.action_mailer.delivery_method = :test
  end

  test 'cron exists?' do
    cron = Delayed::Job.find_by('handler LIKE ?', '%DailySalesReportMailJob%')
    assert cron.present?, "Cron doesn't exist"
    assert_equal '0 7 * * *', cron.cron, 'La hora de ejecución del cron no coincide'
  end

  test 'cron execution' do
    cron = Delayed::Job.find_by('handler LIKE ?', '%DailySalesReportMailJob%')
    assert cron.present?, "Cron doesn't exist"

    TopSalesPerDay.stub :all, @fake_sales do
      assert_difference 'ActionMailer::Base.deliveries.size', +1 do
        cron.invoke_job
      end
    end
  end
end
