require 'spec_helper'

describe MmoStarterKit::Config::HasFields do

  it 'shows hidden fields when added through the DSL' do
    expect(MmoStarterKit.config(Team).fields.detect { |f| f.name == :division_id }).not_to be_visible

    MmoStarterKit.config do |config|
      config.model Team do
        field :division_id
      end
    end

    expect(MmoStarterKit.config(Team).fields.detect { |f| f.name == :division_id }).to be_visible
  end

  it 'does not set visibility for fields with bindings' do
    MmoStarterKit.config do |config|
      config.model Team do
        field :division do
          visible do
            bindings[:controller].current_user.email == 'test@email.com'
          end
        end
      end
    end
    expect { MmoStarterKit.config(Team).fields.detect { |f| f.name == :division } }.not_to raise_error
    expect { MmoStarterKit.config(Team).fields.detect { |f| f.name == :division }.visible? }.to raise_error("undefined method `[]' for nil:NilClass")
  end
end
