# frozen_string_literal: true

class ApiController < ApplicationController
  def health
    render json: { status: 'ok', time: Time.current }
  end
end
