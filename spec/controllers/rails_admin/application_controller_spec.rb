require 'spec_helper'

describe MmoStarterKit::ApplicationController do
  describe '#to_model_name' do
    it 'works with modules' do
      expect(controller.to_model_name('conversations~conversation')).to eq('Conversations::Conversation')
    end
  end

  describe 'helper method _get_plugin_name' do
    it 'works by default' do
      expect(controller.send(:_get_plugin_name)).to eq(['Dummy App', 'Admin'])
    end

    it 'works for static names' do
      MmoStarterKit.config do |config|
        config.main_app_name = %w[static value]
      end
      expect(controller.send(:_get_plugin_name)).to eq(%w[static value])
    end

    it 'works for dynamic names in the controller context' do
      MmoStarterKit.config do |config|
        config.main_app_name = proc { |controller| [Rails.application.engine_name.try(:titleize), controller.params[:action].titleize] }
      end
      controller.params[:action] = 'dashboard'
      expect(controller.send(:_get_plugin_name)).to eq(['Dummy App Application', 'Dashboard'])
    end
  end
end
