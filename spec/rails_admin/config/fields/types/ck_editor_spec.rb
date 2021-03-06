require 'spec_helper'

describe MmoStarterKit::Config::Fields::Types::CKEditor do
  describe 'base_location' do
    before do
      @custom_prefix = '/foo'
      @default_prefix = Rails.application.config.assets.prefix
      Rails.application.config.assets.prefix = @custom_prefix
      MmoStarterKit.config FieldTest do
        field :text_field, :ck_editor
      end
    end

    after do
      Rails.application.config.assets.prefix = @default_prefix
    end

    it 'allows custom assets prefix' do
      expect(
        MmoStarterKit.config(FieldTest).fields.detect { |f| f.name == :text_field }.with(object: FieldTest.new).base_location[0..(@custom_prefix.length - 1)]
      ).to eq @custom_prefix
    end
  end
end
