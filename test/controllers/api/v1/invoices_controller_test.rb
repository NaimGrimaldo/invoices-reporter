# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class InvoicesControllerTest < ActionDispatch::IntegrationTest
      test 'index response' do
        Api::V1::InvoicesController.any_instance.stub(:search, ->(*_args) { invoices_stub }) do
          get api_v1_invoices_path
          assert_response :success
        end
      end

      test 'index cached response' do
        invoices_stub = build_list(:invoice, 3) do |invoice, i|
          invoice.id = i + 1
        end

        Api::V1::InvoicesController.any_instance.stub(:search, ->(*_args) { invoices_stub }) do
          Rails.cache.clear

          get api_v1_invoices_path
          assert_response :success

          cached = Rails.cache.read('invoices/index/')
          assert_not_nil cached, 'first cached response'

          get api_v1_invoices_path
          assert_response :success

          cached2 = Rails.cache.read('invoices/index/')
          assert_equal cached, cached2, 'same content'
        end
      end
    end
  end
end
