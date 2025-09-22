# frozen_string_literal: true

module Api
  module Searchable
    extend ActiveSupport::Concern

    included do
      def search(collection)
        per_page ||= params[:per_page] || 25
        page ||= params[:page]
        scope = collection.ransack(ransack_params).result

        scope.page(page).per(per_page)
      end

      def ransack_params
        initialize_ransack && params[:q]
      end

      private

      def initialize_ransack
        params[:q] ||= {}
      end
    end
  end
end
