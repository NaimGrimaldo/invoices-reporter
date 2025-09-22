# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Api::Renderer
  include Api::ErrorHandler
  include Api::Searchable
end
