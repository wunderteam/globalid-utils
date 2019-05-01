require 'spec_helper'

RSpec.describe GlobalIdValidator do
  let(:model_class) do
    class Model
      include ActiveModel::Validations
      attr_accessor :ref
      validates :ref, global_id: true
    end

    Model
  end

  let(:gid) { 'gid://fish/NeonTetra/1' }

  subject do
    behavior = model_class.new
    behavior.ref = gid
    behavior
  end

  after { Object.send(:remove_const, 'Model') if Object.const_defined?('Model') }

  it { expect(subject).to be_valid }

  context 'with invalid GlobalID' do
    let(:gid) { '//invalid-uri' }

    it { expect(subject).not_to be_valid }
  end
end
