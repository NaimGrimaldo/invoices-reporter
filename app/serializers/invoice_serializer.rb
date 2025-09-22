# frozen_string_literal: true

class InvoiceSerializer
  include FastJsonapi::ObjectSerializer

  attributes :invoice_number, :total, :invoice_date, :status, :active
end
