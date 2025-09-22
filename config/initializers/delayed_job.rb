# frozen_string_literal: true

Delayed::Worker.max_attempts = ENV.fetch('DELAYED_JOB_MAX_ATTEMPTS', 5).to_i
Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 60 # segundos entre reintentos
