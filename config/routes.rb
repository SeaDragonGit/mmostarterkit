MmoStarterKit::Engine.routes.draw do
  controller 'main' do
    MmoStarterKit::Config::Actions.all(:root).each { |action| match "/#{action.route_fragment}", to: action.action_name, as: action.action_name, via: action.http_methods }
    scope ':model_name' do
      MmoStarterKit::Config::Actions.all(:collection).each { |action| match "/#{action.route_fragment}", to: action.action_name, as: action.action_name, via: action.http_methods }
      post '/bulk_action', to: :bulk_action, as: 'bulk_action'
      scope ':id' do
        MmoStarterKit::Config::Actions.all(:member).each { |action| match "/#{action.route_fragment}", to: action.action_name, as: action.action_name, via: action.http_methods }
      end
    end
  end
end
