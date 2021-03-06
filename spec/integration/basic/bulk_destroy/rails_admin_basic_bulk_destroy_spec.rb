require 'spec_helper'

describe 'MmoStarterKit Basic Bulk Destroy' do
  subject { page }

  describe 'successful bulk delete of records', active_record: true do
    before do
      MmoStarterKit::History.destroy_all
      MmoStarterKit.config { |c| c.audit_with :history }
      @players = 3.times.collect { FactoryGirl.create(:player) }
      @delete_ids = @players[0..1].collect(&:id)

      # NOTE: This uses an internal, unsupported capybara API which could break at any moment. We
      # should refactor this test so that it either A) uses capybara's supported API (only GET
      # requests via visit) or B) just uses Rack::Test (and doesn't use capybara for browser
      # interaction like click_button).
      page.driver.browser.reset_host!
      page.driver.browser.process :post, bulk_action_path(bulk_action: 'bulk_delete', model_name: 'player', bulk_ids: @delete_ids, '_method' => 'post')
      click_button "Yes, I'm sure"
    end

    it 'does not contain deleted records' do
      expect(MmoStarterKit::AbstractModel.new('Player').count).to eq(1)
      expect(MmoStarterKit::History.count).to eq(@delete_ids.count)
      MmoStarterKit::History.all.each do |history|
        expect(history.table).to eq('Player')
      end
      MmoStarterKit::History.all.each do |history|
        expect(@delete_ids).to include(history.item)
      end
      expect(page).to have_selector('.alert-success', text: '2 Players successfully deleted')
    end
  end

  describe 'cancelled bulk_deletion' do
    before do
      @players = 3.times.collect { FactoryGirl.create(:player) }
      @delete_ids = @players[0..1].collect(&:id)

      # NOTE: This uses an internal, unsupported capybara API which could break at any moment. We
      # should refactor this test so that it either A) uses capybara's supported API (only GET
      # requests via visit) or B) just uses Rack::Test (and doesn't use capybara for browser
      # interaction like click_button).
      page.driver.browser.reset_host!
      page.driver.browser.process :post, bulk_action_path(bulk_action: 'bulk_delete', model_name: 'player', bulk_ids: @delete_ids, '_method' => 'post')
      click_button 'Cancel'
    end

    it 'does not delete records' do
      expect(MmoStarterKit::AbstractModel.new('Player').count).to eq(3)
    end
  end
end
