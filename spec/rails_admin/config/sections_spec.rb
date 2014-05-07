require 'spec_helper'

describe MmoStarterKit::Config::Sections do

  describe 'configure' do
    it 'configures without changing the section default list' do
      MmoStarterKit.config Team do
        edit do
          configure :name do
            label 'Renamed'
          end
        end
      end
      fields = MmoStarterKit.config(Team).edit.fields
      expect(fields.detect { |f| f.name == :name }.label).to eq('Renamed')
      expect(fields.count).to be >= 19 # not 1
    end

    it 'does not change the section list if set' do
      MmoStarterKit.config Team do
        edit do
          field :manager
          configure :name do
            label 'Renamed'
          end
        end
      end
      fields = MmoStarterKit.config(Team).edit.fields
      expect(fields.first.name).to eq(:manager)
      expect(fields.count).to eq(1) # not 19
    end
  end

  describe 'DSL field inheritance' do
    it 'is tested' do
      MmoStarterKit.config do |config|
        config.model Fan do
          field :name do
            label do
              @label ||= "modified base #{label}"
            end
          end
          list do
            field :name do
              label do
                @label ||= "modified list #{label}"
              end
            end
          end
          edit do
            field :name do
              label do
                @label ||= "modified edit #{label}"
              end
            end
          end
          create do
            field :name do
              label do
                @label ||= "modified create #{label}"
              end
            end
          end
        end

      end
      expect(MmoStarterKit.config(Fan).visible_fields.count).to eq(1)
      expect(MmoStarterKit.config(Fan).visible_fields.first.label).to eq('modified base Their Name')
      expect(MmoStarterKit.config(Fan).list.visible_fields.first.label).to eq('modified list Their Name')
      expect(MmoStarterKit.config(Fan).export.visible_fields.first.label).to eq('modified base Their Name')
      expect(MmoStarterKit.config(Fan).edit.visible_fields.first.label).to eq('modified edit Their Name')
      expect(MmoStarterKit.config(Fan).create.visible_fields.first.label).to eq('modified create Their Name')
      expect(MmoStarterKit.config(Fan).update.visible_fields.first.label).to eq('modified edit Their Name')
    end
  end

  describe 'DSL group inheritance' do
    it 'is tested' do
      MmoStarterKit.config do |config|
        config.model Team do
          list do
            group 'a' do
              field :founded
            end

            group 'b' do
              field :name
              field :wins
            end
          end

          edit do
            group 'a' do
              field :name
            end

            group 'c' do
              field :founded
              field :wins
            end
          end

          update do
            group 'd' do
              field :wins
            end

            group 'e' do
              field :losses
            end
          end
        end
      end

      expect(MmoStarterKit.config(Team).list.visible_groups.collect { |g| g.visible_fields.collect(&:name) }).to eq([[:founded], [:name, :wins]])
      expect(MmoStarterKit.config(Team).edit.visible_groups.collect { |g| g.visible_fields.collect(&:name) }).to eq([[:name], [:founded, :wins]])
      expect(MmoStarterKit.config(Team).create.visible_groups.collect { |g| g.visible_fields.collect(&:name) }).to eq([[:name], [:founded, :wins]])
      expect(MmoStarterKit.config(Team).update.visible_groups.collect { |g| g.visible_fields.collect(&:name) }).to eq([[:name], [:founded], [:wins], [:losses]])
      expect(MmoStarterKit.config(Team).visible_groups.collect { |g| g.visible_fields.collect(&:name) }.flatten.count).to eq(19)
      expect(MmoStarterKit.config(Team).export.visible_groups.collect { |g| g.visible_fields.collect(&:name) }.flatten.count).to eq(19)
    end
  end
end
