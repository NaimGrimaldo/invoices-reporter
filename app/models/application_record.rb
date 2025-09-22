# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include AuthorizableRansackable

  primary_abstract_class
end
