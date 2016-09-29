require 'active_support'
require 'active_model'
require 'globalid'

module URI
  class GID
    # Returns the class constant for the gid's model class. If app matches GlobalID.app, returns
    # constantized model_name. Otherwise, constantizes model_name within app.
    def model_class
      if app.to_s == GlobalID.app.to_s
        model_name.classify.constantize
      else
        "#{app.classify}::#{model_name}".constantize
      end
    end
  end
end

class GlobalID
  # Raise an exception if gid is invalid.
  def self.find!(gid, options = {})
    GlobalID.new(gid)
    find(gid, options)
  end

  module Locator
    def self.locate(gid, _options = {})
      gid = GlobalID.parse(gid)
      gid.model_class.find(gid.model_id) if gid
    end
  end
end

require 'global_id_model'
require 'global_id_validator'
require 'global_id_utils/railtie'
