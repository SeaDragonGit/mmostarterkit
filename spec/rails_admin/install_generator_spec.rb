require 'spec_helper'
require 'generators/rails_admin/install_generator'

describe MmoStarterKit::InstallGenerator, type: :generator do
  destination File.expand_path('../../dummy_app/tmp/generator', __FILE__)
  arguments ['admin']

  before do
    prepare_destination
  end

  it 'mounts MmoStarterKit as Engine and generates MmoStarterKit Initializer' do
    expect_any_instance_of(generator_class).to receive(:route).
      with("mount MmoStarterKit::Engine => '/admin', as: 'mmo_starter_kit'")
    capture(:stdout) do
      generator.invoke('install')
    end
    expect(destination_root).to have_structure{
      directory 'config' do
        directory 'initializers' do
          file 'mmo_starter_kit.rb' do
            contains 'MmoStarterKit.config'
          end
        end
      end
    }
  end
end
