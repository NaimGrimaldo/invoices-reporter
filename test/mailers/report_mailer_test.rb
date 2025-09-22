# frozen_string_literal: true

require 'test_helper'

class ReportMailerTest < ActionMailer::TestCase
  test 'daily report mail is generated correctly' do
    # Datos simulados exactamente como TopSalesPerDay devolvería
    fake_sales = [
      { 'sale_date' => Date.yesterday.to_s, 'total' => 500.0, 'invoices_count' => 3 },
      { 'sale_date' => (Date.yesterday - 1).to_s, 'total' => 300.0, 'invoices_count' => 2 }
    ]

    # Generamos el mail directamente
    mail = ReportMailer.daily_sales_report(fake_sales)

    # Lo enviamos inmediatamente
    mail.deliver_now

    # Debug: imprime los deliveries
    puts "Deliveries: #{ActionMailer::Base.deliveries.inspect}"

    # Verifica que se envió exactamente 1 mail
    assert_equal 1, ActionMailer::Base.deliveries.size, 'Mail not sent'

    email = ActionMailer::Base.deliveries.last

    # Verifica que el contenido tenga los totales
    assert_match '500', email.body.encoded
    assert_match '300', email.body.encoded
  end
end
