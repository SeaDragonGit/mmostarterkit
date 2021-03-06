require 'spec_helper'

describe MmoStarterKit do

  subject { page }

  before do
    MmoStarterKit::Config.authenticate_with { warden.authenticate! scope: :user }
    MmoStarterKit::Config.current_user_method(&:current_user)
    login_as User.create(
      email: 'username@example.com',
      password: 'password'
    )
  end

  # A common mistake for translators is to forget to change the YAML file's
  # root key from en to their own locale (as people tend to use the English
  # file as template for a new translation).
  describe 'localization' do
    it 'defaults to English' do
      MmoStarterKit.config.included_models = []
      visit dashboard_path

      should have_content('Site Administration')
      should have_content('Dashboard')
    end
  end

  describe 'html head' do
    before { visit dashboard_path }

    # Note: the [href^="/asset... syntax matches the start of a value. The reason
    # we just do that is to avoid being confused by rails' asset_ids.
    it 'loads stylesheets in header' do
      should have_selector('head link[href^="/assets/mmo_starter_kit/mmo_starter_kit.css"]', visible: false)
    end

    it 'loads javascript files in body' do
      should have_selector('head script[src^="/assets/mmo_starter_kit/mmo_starter_kit.js"]', visible: false)
    end
  end

  describe 'hidden fields with default values' do

    before do
      MmoStarterKit.config Player do
        include_all_fields
        edit do
          field :name, :hidden do
            default_value do
              bindings[:view]._current_user.email
            end
          end
        end
      end
    end

    it 'shows up with default value, hidden' do
      visit new_path(model_name: 'player')
      should have_selector("#player_name[type=hidden][value='username@example.com']")
      should_not have_selector("#player_name[type=hidden][value='toto@example.com']")
    end

    it 'does not show label' do
      should_not have_selector('label', text: 'Name')
    end

    it 'does not show help block' do
      should_not have_xpath("id('player_name')/../p[@class='help-block']")
    end
  end

  describe '_current_user' do # https://github.com/sferik/mmo_starter_kit/issues/549

    it 'is accessible from the list view' do

      MmoStarterKit.config Player do
        list do
          field :name do
            visible do
              bindings[:view]._current_user.email == 'username@example.com'
            end
          end

          field :team do
            visible do
              bindings[:view]._current_user.email == 'foo@example.com'
            end
          end
        end
      end

      visit index_path(model_name: 'player')
      should have_selector('.header.name_field')
      should_not have_selector('.header.team_field')
    end
  end

  describe 'polymorphic associations' do
    before :each do
      @team = FactoryGirl.create :team
      @comment = FactoryGirl.create :comment, commentable: @team
    end

    it 'works like belongs to associations in the list view' do
      visit index_path(model_name: 'comment')

      should have_content(@team.name)
    end

    it 'is editable' do
      visit edit_path(model_name: 'comment', id: @comment.id)

      should have_selector('select#comment_commentable_type')
      should have_selector('select#comment_commentable_id')
    end

    it 'is visible in the owning end' do
      visit edit_path(model_name: 'team', id: @team.id)

      should have_selector('select#team_comment_ids')
    end
  end

  describe 'secondary navigation' do
    it 'has Gravatar image' do
      visit dashboard_path
      should have_selector('ul.nav.pull-right li img')
    end

    it "does not show Gravatar when user doesn't have email method" do
      allow_any_instance_of(User).to receive(:respond_to?).and_return(true)
      allow_any_instance_of(User).to receive(:respond_to?).with(:email).and_return(false)
      visit dashboard_path
      should_not have_selector('ul.nav.pull-right li img')
    end

    it 'does not cause error when email is nil' do
      allow_any_instance_of(User).to receive(:respond_to?).and_return(true)
      allow_any_instance_of(User).to receive(:respond_to?).with(:email).and_return(nil)
      visit dashboard_path
      should have_selector('body.mmo_starter_kit')
    end

    it 'shows a log out link' do
      visit dashboard_path
      should have_content 'Log out'
    end
  end
end
