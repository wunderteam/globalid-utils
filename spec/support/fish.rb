module Fish
  class Base
    include ::ActiveModel::Model
    include ::GlobalIdUtils::ModelExtensions

    attr_accessor :id, :name

    def initialize(id: nil, name: nil)
      self.id   = id
      self.name = name
    end
  end
end
