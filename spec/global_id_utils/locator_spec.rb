require 'spec_helper'

RSpec.describe GlobalIdUtils::Locator do
  let(:model_class) do
    module Fish
      class NeonTetra < Fish::Base
      end
    end

    Fish::NeonTetra
  end

  before { GlobalID.app = 'testapp' }
  after { Fish.send(:remove_const, 'NeonTetra') if Fish.const_defined?('NeonTetra') }

  describe '::locate' do
    it 'performs an unscoped find' do
      allow(model_class).to receive(:unscoped)
      described_class.locate('gid://fish/NeonTetra/1')
      expect(model_class).to have_received(:unscoped)
    end

    it 'determines the model class and finds the record' do
      allow(model_class).to receive(:find_by)
      described_class.locate('gid://fish/NeonTetra/1')
      expect(model_class).to have_received(:find_by).with(id: '1')
    end

    context 'when the app name is more than one word' do
      let(:model_class) do
        module AquaticLifeforms
          class NeonTetra < Fish::Base
          end
        end

        AquaticLifeforms::NeonTetra
      end

      it 'determines the model class and finds the record' do
        allow(model_class).to receive(:find_by)
        described_class.locate('gid://aquatic-lifeforms/NeonTetra/1')
        expect(model_class).to have_received(:find_by).with(id: '1')
      end
    end

    context 'when the model defines a custom model ID attribute' do
      let(:model_class) do
        module Fish
          class NeonTetra < Fish::Base
            gid_model_id :public_id
          end
        end

        Fish::NeonTetra
      end

      it 'finds the model by the custom attribute' do
        allow(model_class).to receive(:find_by)
        described_class.locate('gid://fish/NeonTetra/public-id-1')
        expect(model_class).to have_received(:find_by).with(public_id: 'public-id-1')
      end
    end
  end

  describe '::locate_many' do
    let(:second_model_class) do
      module Fish
        class SiameseFighting < Fish::Base
        end
      end

      Fish::SiameseFighting
    end

    let(:gids) do
      [
        'gid://fish/NeonTetra/1',
        'gid://fish/SiameseFighting/2',
        'gid://fish/NeonTetra/3',
        'gid://fish/SiameseFighting/4',
        'gid://fish/NeonTetra/5',
        'gid://fish/SiameseFighting/6',
      ].map { |s| GlobalID.parse(s) }
    end

    after { Fish.send(:remove_const, 'SiameseFighting') if Fish.const_defined?('SiameseFighting') }

    it 'performs an unscoped find for each model class' do
      allow(model_class).to receive(:unscoped)
      allow(second_model_class).to receive(:unscoped)

      described_class.locate_many(gids)

      expect(model_class).to have_received(:unscoped).once
      expect(second_model_class).to have_received(:unscoped).once
    end

    it 'performs a find once per model class' do
      neon1, neon3, neon5 = double, double, double
      siamese2, siamese4, siamese6 = double, double, double

      allow(model_class).to receive(:find_by).with(id: ['1', '3', '5']).and_return([neon1, neon3, neon5])
      allow(second_model_class).to receive(:find_by).with(id: ['2', '4', '6']).and_return([siamese2, siamese4, siamese6])

      result = described_class.locate_many(gids)

      expect(model_class).to have_received(:find_by).once
      expect(second_model_class).to have_received(:find_by).once
      expect(result).to contain_exactly(neon1, neon3, neon5, siamese2, siamese4, siamese6)
    end

    it 'performs a "where" find once per model class when the :ignore_missing option is given' do
      neon1, neon3, neon5 = double, double, double
      siamese2, siamese4, siamese6 = double, double, double

      allow(model_class).to receive(:where).with(id: ['1', '3', '5']).and_return([neon1, neon3, neon5])
      allow(second_model_class).to receive(:where).with(id: ['2', '4', '6']).and_return([siamese2, siamese4, siamese6])

      result = described_class.locate_many(gids, ignore_missing: true)

      expect(model_class).to have_received(:where).once
      expect(second_model_class).to have_received(:where).once
      expect(result).to contain_exactly(neon1, neon3, neon5, siamese2, siamese4, siamese6)
    end
  end
end
