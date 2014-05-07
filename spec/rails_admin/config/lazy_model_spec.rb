require 'spec_helper'

describe MmoStarterKit::Config::LazyModel do
  describe '#store' do
    let(:block) { proc { register_instance_option('parameter') } } # an arbitrary instance method we can spy on
    let(:other_block) { proc { register_instance_option('other parameter') } }

    it "doesn't evaluate the block immediately" do
      expect_any_instance_of(MmoStarterKit::Config::Model).not_to receive(:register_instance_option)

      MmoStarterKit::Config::LazyModel.new(:Team, &block)
    end

    it 'evaluates block when reading' do
      expect_any_instance_of(MmoStarterKit::Config::Model).to receive(:register_instance_option).with('parameter')

      lazy_model = MmoStarterKit::Config::LazyModel.new(:Team, &block)
      lazy_model.groups # an arbitrary instance method on MmoStarterKit::Config::Model to wake up lazy_model
    end

    it 'evaluates config block only once' do
      expect_any_instance_of(MmoStarterKit::Config::Model).to receive(:register_instance_option).once.with('parameter')

      lazy_model = MmoStarterKit::Config::LazyModel.new(:Team, &block)
      lazy_model.groups
      lazy_model.groups
    end
  end
end
