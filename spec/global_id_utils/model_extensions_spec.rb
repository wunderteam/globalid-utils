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

  it 'generates a global id' do
    expect(subject.to_gid.to_s).to eq('gid://fish/NeonTetra/1')
  end

  context 'when the class name is two words' do
    let(:model_class) do
      module AquaticLifeforms
        class NeonTetra < Fish::Base
        end
      end

      AquaticLifeforms::NeonTetra
    end

    it 'dasherizes the app name on words' do
      expect(subject.to_gid.to_s).to eq('gid://aquatic-lifeforms/NeonTetra/1')
    end

    it 'can parse a dasherized app name' do
      global_id = GlobalID.parse(subject.to_gid.to_s)
      expect(global_id.model_name).to eq 'NeonTetra'
      expect(global_id.app).to eq 'aquatic-lifeforms'
    end
  end

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

  describe '::gid_model_id_attribute' do
    context 'when a custom model ID is defined' do
      let(:model_class) do
        module Fish
          class NeonTetra < Base
            gid_model_id :name
          end
        end

        Fish::NeonTetra
      end

      it 'returns the custom attribute' do
        expect(subject.class.gid_model_id_attribute).to eq(:name)
      end
    end

    context 'when a custom model ID is not defined' do
      let(:model_class) do
        module Fish
          class NeonTetra < Base
          end
        end

        Fish::NeonTetra
      end

      it 'returns the custom attribute' do
        expect(subject.class.gid_model_id_attribute).to eq(:id)
      end
    end
  end
end
