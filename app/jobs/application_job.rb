# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  rescue_from(StandardError) do |exception|
    Rails.logger.error("[#{self.class.name}] attempt ##{executions}: #{exception.message}")

    if executions < Delayed::Worker.max_attempts
      self.class.set(wait: 1.minute).perform_later(*arguments)
    else
      Rails.logger.error("[#{self.class.name}]  exceeded the number of #{executions} retries")
    end
  end
end
