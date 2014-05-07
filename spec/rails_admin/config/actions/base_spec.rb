require 'spec_helper'

describe MmoStarterKit::Config::Actions::Base do

  describe '#visible?' do
    it 'excludes models not referenced in the only array' do
      MmoStarterKit.config do |config|
        config.actions do
          index do
            only [Player, Cms::BasicPage]
          end
        end
      end
      expect(MmoStarterKit::Config::Actions.find(:index, controller: double(authorized?: true), abstract_model: MmoStarterKit::AbstractModel.new(Player))).to be_visible
      expect(MmoStarterKit::Config::Actions.find(:index, controller: double(authorized?: true), abstract_model: MmoStarterKit::AbstractModel.new(Team))).to be_nil
      expect(MmoStarterKit::Config::Actions.find(:index, controller: double(authorized?: true), abstract_model: MmoStarterKit::AbstractModel.new(Cms::BasicPage))).to be_visible
    end

    it 'excludes models referenced in the except array' do
      MmoStarterKit.config do |config|
        config.actions do
          index do
            except [Player, Cms::BasicPage]
          end
        end
      end
      expect(MmoStarterKit::Config::Actions.find(:index, controller: double(authorized?: true), abstract_model: MmoStarterKit::AbstractModel.new(Player))).to be_nil
      expect(MmoStarterKit::Config::Actions.find(:index, controller: double(authorized?: true), abstract_model: MmoStarterKit::AbstractModel.new(Team))).to be_visible
      expect(MmoStarterKit::Config::Actions.find(:index, controller: double(authorized?: true), abstract_model: MmoStarterKit::AbstractModel.new(Cms::BasicPage))).to be_nil
    end
  end
end
