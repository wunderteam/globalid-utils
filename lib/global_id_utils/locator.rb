module GlobalIdUtils
  module Locator
    def self.locate(gid, scopes = [])
      gid = ::GlobalID.parse(gid)
      model_class = gid.model_class
      unscoped(model_class) do
        relation = model_class
        scopes.each { |scope| relation.send(scope.name, *scope.args) }
        relation.find_by!(model_class.gid_model_id_attribute => gid.model_id)
      end
    end

    def self.locate_many(gids, options = {})
      models_and_ids = gids.each_with_object({}) { |gid, hsh| (hsh[gid.model_class] ||= []) << gid.model_id }
      models_and_ids.map { |model_class, ids| find_records(model_class, ids, options) }.flatten
    end

    def self.find_records(model_class, ids, options)
      ids = ids.compact.uniq

      unscoped(model_class) do
        rel = model_class.where(model_class.gid_model_id_attribute => ids)

        unless options[:ignore_missing]
          found_ids = rel.pluck(model_class.gid_model_id_attribute)
          not_found_ids = ids.map(&:to_s) - found_ids.map(&:to_s)

          if ids.count != found_ids.count
            rel.raise_record_not_found_exception!(
              ids,
              found_ids.count,
              ids.count,
              model_class.gid_model_id_attribute,
              not_found_ids,
            )
          end
        end

        rel
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
  end
end
