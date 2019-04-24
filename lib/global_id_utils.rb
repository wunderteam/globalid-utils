require 'active_support'
require 'active_model'
require 'globalid'

require 'global_id_validator'
require 'global_id_utils/locator'
require 'global_id_utils/model_extensions'
require 'global_id_utils/railtie'

class GlobalID
  module Locator
    def self.locate(gid, options = {})
      ::GlobalIdUtils::Locator.locate(gid)
    end

    def self.locate_many(gids, options = {})
      ::GlobalIdUtils::Locator.locate_many(gids, options)
    end
  end

  # Raise if gid is invalid
  def self.find!(gid, options = {})
    find(new(gid), options)
  end

  def self.find_many(gids, options = {})
    gids = gids.map { |gid| parse(gid) }.compact
    Locator.locate_many(gids, options)
  end

  # Raise if any gid is invalid
  def self.find_many!(gids, options = {})
    gids = gids.map { |gid| new(gid) }
    find_many(gids, options)
  end
end
