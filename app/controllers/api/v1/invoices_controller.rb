# frozen_string_literal: true

module Api
  module V1
    class InvoicesController < ApplicationController
      def index
        invoices = Rails.cache.fetch(cache_key, expires_in: 30.seconds) do
          collection = search(Invoice).order(invoice_date: :desc)
          serialized_instance(
            collection, InvoiceSerializer, { meta: meta_pagination_for(collection) }
          )
        end

        render json: invoices.to_json
      end

      private

      def cache_key
        [
          'invoices/index',
          params.to_unsafe_h.to_param
        ].join('/')
      end
    end
  end
end
