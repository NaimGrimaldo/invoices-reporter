# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/mock'
require 'rake'
require 'delayed_job_active_record'
require 'mocha/minitest'

Rails.application.load_tasks
Rake::Task['db:test:prepare'].invoke

module ActiveSupport
  class TestCase
    include FactoryBot::Syntax::Methods

    parallelize(workers: :number_of_processors)

    # Helper para simular respuestas de ContalinkRecord.connection.exec_query
    def with_fake_exec_query(fake_result)
      fake_connection = Object.new
      fake_connection.define_singleton_method(:exec_query) { |_sql| fake_result }

      # Redefinimos connection temporalmente
      original_connection = ContalinkRecord.connection
      ContalinkRecord.singleton_class.define_method(:connection) { fake_connection }

      yield
    ensure
      ContalinkRecord.singleton_class.define_method(:connection) { original_connection }
    end
  end
end

module ActionMailer
  class TestCase
    setup { ActionMailer::Base.deliveries.clear }
  end
end

module ActiveJob
  class TestCase
    include ActiveJob::TestHelper

    setup { ActiveJob::Base.queue_adapter = :test }
  end
end
