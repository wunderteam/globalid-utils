module GlobalIdUtils
  module Locator
    def self.locate(gid)
      gid = ::GlobalID.parse(gid)
      model_class = model_class_for(gid)
      unscoped(model_class) { find(model_class, gid.model_id) }
    end

    def self.locate_many(gids, options = {})
      models_and_ids = gids.each_with_object({}) { |gid, hsh| (hsh[model_class_for(gid)] ||= []) << gid.model_id }
      models_and_ids.map { |model_class, ids| find_records(model_class, ids, options) }.flatten
    end

    def self.model_class_for(gid)
      if gid.app.to_s == ::GlobalID.app.to_s
        gid.model_name.classify.constantize
      else
        "#{gid.app.underscore.camelize}::#{gid::model_name}".constantize
      end
    end
    private_class_method :model_class_for

    def self.find_records(model_class, ids, options)
      unscoped(model_class) do
        if options[:ignore_missing]
          model_class.where(model_class.gid_model_id_attribute => ids)
        else
          find(model_class, ids)
        end
      end.to_a
    end
    private_class_method :find_records

    def self.unscoped(model_class)
      if model_class.respond_to?(:unscoped)
        model_class.unscoped { yield }
      else
        yield
      end
    end
    private_class_method :unscoped

    def self.find(model_class, id)
      model_class.find_by(model_class.gid_model_id_attribute => id)
    end
    private_class_method :find
  end
end
