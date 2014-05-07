require 'spec_helper'

describe MmoStarterKit::Config::Fields::Types::FileUpload do
  describe '#allowed_methods' do
    it 'includes delete_method and cache_method' do
      MmoStarterKit.config do |config|
        config.model FieldTest do
          field :carrierwave_asset
          field :dragonfly_asset
          field :paperclip_asset do
            delete_method :delete_paperclip_asset
          end
        end
      end
      expect(MmoStarterKit.config(FieldTest).field(:carrierwave_asset).allowed_methods.collect(&:to_s)).to eq %w[carrierwave_asset remove_carrierwave_asset carrierwave_asset_cache]
      expect(MmoStarterKit.config(FieldTest).field(:dragonfly_asset).allowed_methods.collect(&:to_s)).to eq %w[dragonfly_asset remove_dragonfly_asset retained_dragonfly_asset]
      expect(MmoStarterKit.config(FieldTest).field(:paperclip_asset).allowed_methods.collect(&:to_s)).to eq %w[paperclip_asset delete_paperclip_asset]
    end
  end
end
