# frozen_string_literal: true

class ContalinkRecord < ApplicationRecord
  self.abstract_class = true

  establish_connection :secondary
end
