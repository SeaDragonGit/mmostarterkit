require 'spec_helper'

describe MmoStarterKit::CSVConverter do
  it 'keeps headers ordering' do
    MmoStarterKit.config(Player) do
      export do
        field :number
        field :name
      end
    end

    FactoryGirl.create :player
    objects = Player.all
    schema = {only: [:number, :name]}
    expect(MmoStarterKit::CSVConverter.new(objects, schema).to_csv({})[2]).to match(/Number,Name/)
  end
end
