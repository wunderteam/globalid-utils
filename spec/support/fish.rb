module Fish
  class Base
    include ::ActiveModel::Model
    include ::GlobalIdUtils::ModelExtensions

    attr_accessor :id, :name

    def initialize(id: nil, name: nil)
      self.id   = id
      self.name = name
    end

    # Scopes

    def self.with_name(name)
      [random_fish]
    end

    def self.with_fins
      [random_fish]
    end

    def self.with_eyes
      [random_fish]
    end

    # AR Stubs

    def self.unscoped
      yield
    end

    def self.find_by!(**args)
      random_fish
    end

    def self.where(*_args)
      [random_fish]
    end

    # Private

    def self.random_fish
      ::Fish::Base.new(id: rand(1..1000), name: SecureRandom.uuid)
    end
    private_class_method :random_fish
  end
end
