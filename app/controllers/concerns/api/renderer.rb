# frozen_string_literal: true

module Api
  module Renderer
    extend ActiveSupport::Concern

    DEFAULT_ERROR_STRUCT = {
      full_messages: [], message_type: 'error', code: 'ERROR'
    }.freeze

    included do
      def render_with(object, serializer_class, options = {})
        serialized_instance = serialized_instance(
          object, serializer_class, options
        )

        render(json: serialized_instance.to_json) and return
      end

      def render_created(object, serializer_class, options = {})
        serialized_instance = serialized_instance(
          object, serializer_class, options
        )

        render(json: serialized_instance.to_json, status: :created)
      end

      def render_unprocessable_entity(obj, serializer = nil,
                                      custom_error: false)
        if serializer
          render(
            json: serializer.new(obj, meta_errors(obj)),
            status: obj.errors.status
          )
        elsif custom_error
          render_custom_error(object: obj.errors, status: obj.errors.status)
        else
          render_error(object: obj.errors, status: obj.errors.status)
        end
      end

      def render_forbidden
        render_error(
          { full_messages: ['No estás autorizado para realizar esta acción'] },
          status: :forbidden
        ) && return
      end

      def render_bad_request
        render_error(
          { full_messages: [
            'Bad request, falta el parámetro o su valor está vacío'
          ] }, status: :bad_request
        ) && return
      end

      def render_not_found
        render_error(
          { full_messages: ['Record not found'] }, status: :not_found
        ) && return
      end

      def render_unauthorized(entity = 'user')
        render_error(
          { full_messages: ["Unauthorized #{entity}"] }, status: :unauthorized
        ) && return
      end

      def internal_server_error
        render_error(
          { full_messages: ['Internal server error'] }, status: :internal_server_error
        ) && return
      end

      def serialized_instance(object, serializer_class, options = {})
        serializer_class.new(object, options).serializable_hash
      end

      private

      def render_error(args = {}, status:, object: nil)
        render(
          json: ErrorDecorator.decorate(
            object || OpenStruct.new(
              DEFAULT_ERROR_STRUCT.merge(
                args.slice(:full_messages, :message_type, :code)
              )
            )
          ).structure, status: status
        )
      end

      def render_custom_error(status:, object: nil)
        render(json: object.messages, status: status)
      end

      def serialized_instance(object, serializer_class, options = {})
        serializer_class.new(object, options).serializable_hash
      end

      def meta_pagination_for(object)
        if object.respond_to?(:raw_answer)
          meta_pagination_when_raw(object.raw_answer)
        else
          meta_pagination_when_collection(object)
        end
      end

      def meta_pagination_when_collection(object)
        {
          total: object&.total_count,
          current_page: object&.current_page,
          total_pages: object&.total_pages,
          next_page: object&.next_page,
          prev_page: object&.prev_page,
          per_page: object&.limit_value
        }
      end

      def meta_pagination_when_raw(raw)
        {
          total: raw['nbHits'],
          current_page: raw['page'].to_i + 1,
          total_pages: raw['nbPages'],
          per_page: raw['hitsPerPage']
        }
      end

      def meta_errors(object)
        { meta: ErrorDecorator.decorate(object.errors).structure }
      end
    end
  end
end
