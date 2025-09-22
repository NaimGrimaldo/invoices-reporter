# frozen_string_literal: true

class ErrorDecorator < Draper::Decorator
  def structure
    {
      error: {
        messages: object.try(:full_messages)&.compact,
        type: object.try(:message_type),
        code: object.try(:code)
      }
    }
  end
end
