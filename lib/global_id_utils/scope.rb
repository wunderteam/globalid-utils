module GlobalIdUtils
  class Scope
    attr_reader :name, :args

    def self.build_many_from(*scopes)
      scopes.map { |scope| build_from(scope) }
    end

    def self.build_from(scope)
      case scope
      when GlobalIdUtils::Scope
        scope
      when Symbol, String
        new(scope)
      else
        raise TypeError, "#{scope.class.name} can't be coerced into #{self.name}"
      end
    end

    def initialize(name, *args)
      @name = name.to_sym
      @args = args
    end
  end
end
