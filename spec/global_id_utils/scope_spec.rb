require 'spec_helper'

RSpec.describe GlobalIdUtils::Scope do
  describe 'initialization' do
    it 'creates a new Scope object' do
      obj = described_class.new(:scope_name, 'arg1', 'arg2')
      expect(obj.name).to eq(:scope_name)
      expect(obj.args).to contain_exactly('arg1', 'arg2')
    end

    it 'can create a scope with no args' do
      obj = described_class.new(:scope_name)
      expect(obj.name).to eq(:scope_name)
      expect(obj.args).to eq([])
    end

    it 'can create a scope with a string name' do
      obj = described_class.new('scope_name')
      expect(obj.name).to eq(:scope_name)
    end
  end

  describe '::build_from' do
    it 'retruns the existing Scope when built from a Scope' do
      existing = described_class.new(:scope_name)
      new = described_class.build_from(existing)
      expect(new).to eq(existing)
    end

    it 'will build a new scope when passed a string' do
      scope = described_class.build_from("scope_name")
      expect(scope.name).to eq(:scope_name)
    end

    it 'will build a new scope when passed a symbol' do
      scope = described_class.build_from(:scope_name)
      expect(scope.name).to eq(:scope_name)
    end
  end

  describe '::build_many_from' do
    it 'coerces all inputs to existing or new Scopes' do
      existing = described_class.new(:scope1, "arg1")
      result = described_class.build_many_from(existing, "scope2", :scope3)
      expect(result.map(&:name)).to contain_exactly(:scope1, :scope2, :scope3)
    end
  end
end
