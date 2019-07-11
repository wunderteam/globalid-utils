# Allows customization of GlobalID parameters on a per-model basis.
#
# Usage:
#
# class SiameseFighting < ActiveRecord::Base
#   gid_app        'fighting-fish'
#   gid_model_name 'Bully'
#   gid_model_id   :name
# end
#
# GlobalID.app # => "fish"
# SiameseFighting.find_by(name: 'Pedro').to_gid.to_s # => "gid://fighting-fish/Bully/Pedro"
module GlobalIdUtils
  module ModelExtensions
    extend ActiveSupport::Concern

    included do
      alias_method :to_gid, :to_global_id
      alias_method :to_sgid, :to_secure_global_id
    end

    class_methods do
      def gid_app(app)
        URI::GID.validate_app(app)
        class_variable_set(:@@gid_app, app.to_s)
      end

      def gid_model_name(model_name)
        unless model_name.present?
          raise ArgumentError, 'Invalid model_name for GlobalID'
        end

        class_variable_set(:@@gid_model_name, model_name.to_s)
      end

      def gid_model_id(model_id)
        unless model_id.is_a?(Symbol)
          raise ArgumentError, 'Invalid model_id for GlobalID'
        end

        class_variable_set(:@@gid_model_id, model_id)
      end

      def gid_model_id_attribute
        return :id unless class_variable_defined?(:@@gid_model_id)
        class_variable_get(:@@gid_model_id)
      end
    end

    def to_global_id(options = {})
      @global_id ||= begin
        app        = resolve_gid_app
        model_name = resolve_gid_model_name
        model_id   = resolve_gid_model_id
        params     = options.except(:app, :verifier, :for)

        GlobalID.new(
          URI::GID.build(app: app, model_name: model_name, model_id: model_id, params: params),
          options
        )
      end
    end

    def to_secure_global_id(options = {})
      app        = resolve_gid_app
      model_name = resolve_gid_model_name
      model_id   = resolve_gid_model_id
      params     = options.except(:app, :verifier, :for)

      SignedGlobalID.new(
        URI::GID.build(app: app, model_name: model_name, model_id: model_id, params: params),
        options
      )
    end

    private

    def resolve_gid_app
      return self.class.class_variable_get(:@@gid_app) if self.class.class_variable_defined?(:@@gid_app)
      return self.class.name.split('::').first.underscore.dasherize if self.class.parent != ::Object

      ::GlobalID.app
    end

    def resolve_gid_model_name
      return self.class.class_variable_get(:@@gid_model_name) if self.class.class_variable_defined?(:@@gid_model_name)
      return self.class.name.split('::').slice(1..-1).join('::') if self.class.parent != ::Object

      self.class.name
    end

    def resolve_gid_model_id
      send(self.class.gid_model_id_attribute)
    end
  end
end
