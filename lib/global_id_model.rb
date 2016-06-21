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
# SiameseFighting.find_by(name: 'Pedro').to_ref # => "gid://fighting-fish/Bully/Pedro"
module GlobalIdModel
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
      unless model_id.is_a?(Symbol) || model_id.respond_to?(:call)
        raise ArgumentError, 'Invalid model_id for GlobalID'
      end

      class_variable_set(:@@gid_model_id, model_id)
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
    klass = self.class

    if klass.class_variable_defined?(:@@gid_app)
      return klass.class_variable_get(:@@gid_app)
    end

    if klass.parent != Object
      return klass.name.split('::').first.downcase
    end

    GlobalID.app
  end

  def resolve_gid_model_name
    klass = self.class

    if klass.class_variable_defined?(:@@gid_model_name)
      return klass.class_variable_get(:@@gid_model_name)
    end

    if klass.parent != Object
      return klass.name.split('::').slice(1..-1).join('::')
    end

    self.class.name
  end

  def resolve_gid_model_id
    return id unless self.class.class_variable_defined?(:@@gid_model_id)

    model_id = self.class.class_variable_get(:@@gid_model_id)

    if model_id.is_a?(Symbol)
      send(model_id)
    elsif model_id.respond_to?(:call)
      model_id.call(self)
    else
      id
    end
  end
end
