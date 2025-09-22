# frozen_string_literal: true

if ENV['SMTP_ADDRESS'].present? && ENV['SMTP_USER_NAME'].present? && ENV['SMTP_PASSWORD'].present?
  Rails.application.config.action_mailer.delivery_method = :smtp
  Rails.application.config.action_mailer.smtp_settings = {
    address: ENV.fetch('SMTP_ADDRESS', nil),
    port: ENV.fetch('SMTP_PORT', 587),
    domain: ENV.fetch('SMTP_DOMAIN', 'example.com'),
    user_name: ENV.fetch('SMTP_USER_NAME', nil),
    password: ENV.fetch('SMTP_PASSWORD', nil),
    authentication: ENV.fetch('SMTP_AUTH', 'plain'),
    enable_starttls_auto: true
  }

  Rails.logger.info 'ActionMailer SMTP init'
elsif Rails.env.development?
  Rails.application.config.action_mailer.delivery_method = :letter_opener
  Rails.application.config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  Rails.logger.info 'ActionMailer Letter Opener (development)'
end

# Opciones comunes
Rails.application.config.action_mailer.perform_deliveries = true
Rails.application.config.action_mailer.raise_delivery_errors = true
