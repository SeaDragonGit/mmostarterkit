require 'spec_helper'

describe 'MmoStarterKit History', active_record: true do
  describe 'model history fetch' do
    before :each do
      MmoStarterKit::History.delete_all
      @model = MmoStarterKit::AbstractModel.new('Player')
      player = FactoryGirl.create :player
      30.times do |i|
        player.number = i
        MmoStarterKit::History.create_history_item "change #{i}", player, @model, nil
      end
    end

    it 'fetches on page of history' do
      histories = MmoStarterKit::History.history_for_model @model, nil, false, false, false, nil, 20
      expect(histories.total_count).to eq(30)
      expect(histories.count).to eq(20)
    end

    it 'respects MmoStarterKit::Config.default_items_per_page' do
      MmoStarterKit.config.default_items_per_page = 15
      histories = MmoStarterKit::History.history_for_model @model, nil, false, false, false, nil
      expect(histories.total_count).to eq(30)
      expect(histories.count).to eq(15)
    end

    context 'with Kaminari' do
      before do
        Kaminari.config.page_method_name = :per_page_kaminari
        @paged = MmoStarterKit::History.page(1)
      end

      after do
        Kaminari.config.page_method_name = :page
      end

      it "supports pagination when Kaminari's page_method_name is customized" do
        expect(MmoStarterKit::History).to receive(:per_page_kaminari).twice.and_return(@paged)
        MmoStarterKit::History.history_for_model @model, nil, false, false, false, nil
        MmoStarterKit::History.history_for_object @model, Player.first, nil, false, false, false, nil
      end
    end

    context 'GET admin/history/@model' do
      before :each do
        MmoStarterKit.config do |c|
          c.audit_with :history
        end

        visit history_index_path(@model)
      end

      # https://github.com/sferik/mmo_starter_kit/issues/362
      # test that no link uses the "wildcard route" with the history
      # controller and for_model method
      it "does not use the 'wildcard route'" do
        expect(page).to have_selector("a[href*='all=true']") # make sure we're fully testing pagination
        expect(page).to have_no_selector("a[href^='/mmo_starter_kit/history/for_model']")
      end

      context 'with a lot of histories' do
        before :each do
          player = Player.create(team_id: -1, number: -1, name: 'Player 1')
          101.times do |i|
            player.number = i
            MmoStarterKit::History.create_history_item "change #{i}", player, @model, nil
          end
        end

        it 'gets latest ones' do
          expect(MmoStarterKit::History.latest.count).to eq(100)
        end

        it 'gets latest ones orderly' do
          latest = MmoStarterKit::History.latest
          expect(latest.first.message).to eq('change 100')
          expect(latest.last.message).to eq('change 1')
        end

        it 'renders a XHR request successfully' do
          xhr :get, history_index_path(@model, page: 2)
        end
      end
    end
  end

end
