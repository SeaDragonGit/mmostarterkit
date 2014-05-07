require 'spec_helper'

describe MmoStarterKit::Config do

  describe '.included_models' do

    it 'only uses included models' do
      MmoStarterKit.config.included_models = [Team, League]
      expect(MmoStarterKit::AbstractModel.all.collect(&:model)).to eq([League, Team]) # it gets sorted
    end

    it 'does not restrict models if included_models is left empty' do
      MmoStarterKit.config.included_models = []
      expect(MmoStarterKit::AbstractModel.all.collect(&:model)).to include(Team, League)
    end

    it 'removes excluded models (whitelist - blacklist)' do
      MmoStarterKit.config.excluded_models = [Team]
      MmoStarterKit.config.included_models = [Team, League]
      expect(MmoStarterKit::AbstractModel.all.collect(&:model)).to eq([League])
    end

    it 'always excludes history', active_record: true do
      expect(MmoStarterKit::AbstractModel.all.collect(&:model)).not_to include(MmoStarterKit::History)
    end

    it 'excluded? returns true for any model not on the list' do
      MmoStarterKit.config.included_models = [Team, League]

      team_config = MmoStarterKit::AbstractModel.new('Team').config
      fan_config = MmoStarterKit::AbstractModel.new('Fan').config

      expect(fan_config).to be_excluded
      expect(team_config).not_to be_excluded
    end
  end

  describe '.add_extension' do
    before do
      silence_warnings do
        MmoStarterKit::EXTENSIONS = []
      end
    end

    it 'registers the extension with MmoStarterKit' do
      MmoStarterKit.add_extension(:example, ExampleModule)
      expect(MmoStarterKit::EXTENSIONS.select { |name| name == :example }.length).to eq(1)
    end

    context 'given an extension with an authorization adapter' do
      it 'registers the adapter' do
        MmoStarterKit.add_extension(:example, ExampleModule,
                                 authorization: true
        )
        expect(MmoStarterKit::AUTHORIZATION_ADAPTERS[:example]).to eq(ExampleModule::AuthorizationAdapter)
      end
    end

    context 'given an extension with an auditing adapter' do
      it 'registers the adapter' do
        MmoStarterKit.add_extension(:example, ExampleModule,
                                 auditing: true
        )
        expect(MmoStarterKit::AUDITING_ADAPTERS[:example]).to eq(ExampleModule::AuditingAdapter)
      end
    end

    context 'given an extension with a configuration adapter' do
      it 'registers the adapter' do
        MmoStarterKit.add_extension(:example, ExampleModule,
                                 configuration: true
        )
        expect(MmoStarterKit::CONFIGURATION_ADAPTERS[:example]).to eq(ExampleModule::ConfigurationAdapter)
      end
    end
  end

  describe '.main_app_name' do

    it 'as a default meaningful dynamic value' do
      expect(MmoStarterKit.config.main_app_name.call).to eq(['Dummy App', 'Admin'])
    end

    it 'can be configured' do
      MmoStarterKit.config do |config|
        config.main_app_name = %w[stati c value]
      end
      expect(MmoStarterKit.config.main_app_name).to eq(%w[stati c value])
    end
  end

  describe '.authorize_with' do
    context 'given a key for a extension with authorization' do
      before do
        MmoStarterKit.add_extension(:example, ExampleModule,
                                 authorization: true
        )
      end

      it 'initializes the authorization adapter' do
        expect(ExampleModule::AuthorizationAdapter).to receive(:new).with(MmoStarterKit::Config)
        MmoStarterKit.config do |config|
          config.authorize_with(:example)
        end
        MmoStarterKit.config.authorize_with.call
      end

      it 'passes through any additional arguments to the initializer' do
        options = {option: true}
        expect(ExampleModule::AuthorizationAdapter).to receive(:new).with(MmoStarterKit::Config, options)
        MmoStarterKit.config do |config|
          config.authorize_with(:example, options)
        end
        MmoStarterKit.config.authorize_with.call
      end
    end
  end

  describe '.audit_with' do
    context 'given a key for a extension with auditing' do
      before do
        MmoStarterKit.add_extension(:example, ExampleModule,
                                 auditing: true
        )
      end

      it 'initializes the auditing adapter' do
        expect(ExampleModule::AuditingAdapter).to receive(:new).with(MmoStarterKit::Config)
        MmoStarterKit.config do |config|
          config.audit_with(:example)
        end
        MmoStarterKit.config.audit_with.call
      end

      it 'passes through any additional arguments to the initializer' do
        options = {option: true}
        expect(ExampleModule::AuditingAdapter).to receive(:new).with(MmoStarterKit::Config, options)
        MmoStarterKit.config do |config|
          config.audit_with(:example, options)
        end
        MmoStarterKit.config.audit_with.call
      end
    end

    context 'given paper_trail as the extension for auditing', active_record: true do
      before do
        module PaperTrail; end
        class Version; end
        MmoStarterKit.add_extension(:example, MmoStarterKit::Extensions::PaperTrail,
                                 auditing: true
        )
      end

      it 'initializes the auditing adapter' do
        MmoStarterKit.config do |config|
          config.audit_with(:example)
        end
        expect { MmoStarterKit.config.audit_with.call }.not_to raise_error
      end
    end
  end

  describe '.configure_with' do
    context 'given a key for a extension with configuration' do
      before do
        MmoStarterKit.add_extension(:example, ExampleModule,
                                 configuration: true
        )
      end

      it 'initializes configuration adapter' do
        expect(ExampleModule::ConfigurationAdapter).to receive(:new)
        MmoStarterKit.config do |config|
          config.configure_with(:example)
        end
      end

      it 'yields the (optionally) provided block, passing the initialized adapter' do
        configurator = nil
        MmoStarterKit.config do |config|
          config.configure_with(:example) do |configuration_adapter|
            configurator = configuration_adapter
          end
        end
        expect(configurator).to be_a(ExampleModule::ConfigurationAdapter)
      end
    end
  end

  describe '.config' do
    context '.default_search_operator' do
      it 'sets the default_search_operator' do
        MmoStarterKit.config do |config|
          config.default_search_operator = 'starts_with'
        end
        expect(MmoStarterKit::Config.default_search_operator).to eq('starts_with')
      end

      it 'errors on unrecognized search operator' do
        expect do
          MmoStarterKit.config do |config|
            config.default_search_operator = 'random'
          end
        end.to raise_error(ArgumentError, "Search operator 'random' not supported")
      end

      it "defaults to 'default'" do
        expect(MmoStarterKit::Config.default_search_operator).to eq('default')
      end
    end
  end

  describe '.visible_models' do
    it 'passes controller bindings, find visible models, order them' do
      MmoStarterKit.config do |config|
        config.included_models = [Player, Fan, Comment, Team]

        config.model Player do
          hide
        end
        config.model Fan do
          weight(-1)
          show
        end
        config.model Comment do
          visible do
            bindings[:controller]._current_user.role == :admin
          end
        end
        config.model Team do
          visible do
            bindings[:controller]._current_user.role != :admin
          end
        end
      end

      expect(MmoStarterKit.config.visible_models(controller: double(_current_user: double(role: :admin), authorized?: true)).collect(&:abstract_model).collect(&:model)).to match_array [Fan, Comment]
    end

    it 'hides unallowed models' do
      MmoStarterKit.config do |config|
        config.included_models = [Comment]
      end
      expect(MmoStarterKit.config.visible_models(controller: double(authorized?: true)).collect(&:abstract_model).collect(&:model)).to eq([Comment])
      expect(MmoStarterKit.config.visible_models(controller: double(authorized?: false)).collect(&:abstract_model).collect(&:model)).to eq([])
    end

    it 'does not contain embedded model', mongoid: true do
      MmoStarterKit.config do |config|
        config.included_models = [FieldTest, Comment, Embed]
      end

      expect(MmoStarterKit.config.visible_models(controller: double(_current_user: double(role: :admin), authorized?: true)).collect(&:abstract_model).collect(&:model)).to match_array [FieldTest, Comment]
    end

    it 'basically does not contain embedded model except model using recursively_embeds_many or recursively_embeds_one', mongoid: true do
      class RecursivelyEmbedsOne
        include Mongoid::Document
        recursively_embeds_one
      end
      class RecursivelyEmbedsMany
        include Mongoid::Document
        recursively_embeds_many
      end
      MmoStarterKit.config do |config|
        config.included_models = [FieldTest, Comment, Embed, RecursivelyEmbedsMany, RecursivelyEmbedsOne]
      end
      expect(MmoStarterKit.config.visible_models(controller: double(_current_user: double(role: :admin), authorized?: true)).collect(&:abstract_model).collect(&:model)).to match_array [FieldTest, Comment, RecursivelyEmbedsMany, RecursivelyEmbedsOne]
    end
  end

  describe '.models_pool' do
    it 'should not include classnames start with Concerns::' do
      expect(MmoStarterKit::Config.models_pool.select { |m| m.match(/^Concerns::/) }).to be_empty
    end
  end
end

module ExampleModule
  class AuthorizationAdapter ; end
  class ConfigurationAdapter ; end
  class AuditingAdapter ; end
end
