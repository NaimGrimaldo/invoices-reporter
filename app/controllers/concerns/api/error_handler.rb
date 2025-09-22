# frozen_string_literal: true

module Api
  module ErrorHandler
    extend ActiveSupport::Concern

    included do
      rescue_from ActiveRecord::RecordNotFound do |error|
        log_error(error)
        render_not_found
      end

      rescue_from ActionController::ParameterMissing do |error|
        log_error(error)
        render_bad_request
      end

      def log_error(error)
        Rails.logger.error(error)
      end
    end
  end
end
