require 'spec_helper'

RSpec.describe GlobalIdUtils::ModelExtensions do
  let(:model_class) do
    module Fish
      class NeonTetra < Base
      end
    end

    Fish::NeonTetra
  end

  subject do
    fish      = model_class.new
    fish.id   = 1
    fish.name = 'Pedro'
    fish
  end

  before { GlobalID.app = 'fish' }
  after  { Fish.send(:remove_const, 'NeonTetra') if Fish.const_defined?('NeonTetra') }

  it { expect(subject.to_gid.to_s).to eq('gid://fish/NeonTetra/1') }

  describe '::gid_app' do
    let(:model_class) do
      module Fish
        class NeonTetra < Base
          gid_app 'fishies'
        end
      end

      Fish::NeonTetra
    end

    it { expect(subject.to_gid.to_s).to eq('gid://fishies/NeonTetra/1') }
  end

  describe '::gid_model_name' do
    let(:model_class) do
      module Fish
        class NeonTetra < Base
          gid_model_name 'neon'
        end
      end

      Fish::NeonTetra
    end

    it { expect(subject.to_gid.to_s).to eq('gid://fish/neon/1') }
  end

  describe '::gid_model_id' do
    let(:model_class) do
      module Fish
        class NeonTetra < Base
          gid_model_id :name
        end
      end

      Fish::NeonTetra
    end

    it { expect(subject.to_gid.to_s).to eq('gid://fish/NeonTetra/Pedro') }
  end
end
