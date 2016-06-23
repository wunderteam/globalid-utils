require 'active_support'
require 'active_model'
require 'globalid'

class GlobalID
  # Raise an exception if gid is invalid.
  def self.find!(gid, options = {})
    GlobalID.new(gid)
    find(gid, options)
  end

  module Locator
    # If given gid's app does not match GlobalID.app, constantize the gid's app and look up the
    # the model within it. Otherwise, find the model normally.
    def self.locate(gid, _options = {})
      if (gid = GlobalID.parse(gid))
        return gid.model_name.classify.constantize.find(gid.model_id) if gid.app.to_s == GlobalID.app.to_s
        "#{gid.app.classify}::#{gid.model_name}".constantize.find(gid.model_id)
      end
    end
  end
end

require 'global_id_model'
require 'global_id_validator'
require 'global_id_utils/railtie'
