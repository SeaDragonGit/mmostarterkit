require 'rails_admin/abstract_model'

module MmoStarterKit
  class ModelNotFound < ::StandardError
  end

  class ObjectNotFound < ::StandardError
  end

  class ApplicationController < ::ApplicationController
    newrelic_ignore if defined?(NewRelic) && respond_to?(:newrelic_ignore)

    before_filter :_authenticate!
    before_filter :_authorize!
    before_filter :_audit!

    helper_method :_current_user, :_get_plugin_name

    attr_reader :object, :model_config, :abstract_model

    def get_model
      @model_name = to_model_name(params[:model_name])
      fail(MmoStarterKit::ModelNotFound) unless (@abstract_model = MmoStarterKit::AbstractModel.new(@model_name))
      fail(MmoStarterKit::ModelNotFound) if (@model_config = @abstract_model.config).excluded?
      @properties = @abstract_model.properties
    end

    def get_object
      fail(MmoStarterKit::ObjectNotFound) unless (@object = @abstract_model.get(params[:id]))
    end

    def to_model_name(param)
      param.split('~').collect(&:camelize).join('::')
    end

  private

    def _get_plugin_name
      @plugin_name_array ||= [RailsAdmin.config.main_app_name.is_a?(Proc) ? instance_eval(&RailsAdmin.config.main_app_name) : RailsAdmin.config.main_app_name].flatten
    end

    def _authenticate!
      instance_eval(&MmoStarterKit::Config.authenticate_with)
    end

    def _authorize!
      instance_eval(&MmoStarterKit::Config.authorize_with)
    end

    def _audit!
      instance_eval(&MmoStarterKit::Config.audit_with)
    end

    def _current_user
      instance_eval(&MmoStarterKit::Config.current_user_method)
    end

    alias_method :user_for_paper_trail, :_current_user

    rescue_from MmoStarterKit::ObjectNotFound do
      flash[:error] = I18n.t('admin.flash.object_not_found', model: @model_name, id: params[:id])
      params[:action] = 'index'
      index
    end

    rescue_from MmoStarterKit::ModelNotFound do
      flash[:error] = I18n.t('admin.flash.model_not_found', model: @model_name)
      params[:action] = 'dashboard'
      dashboard
    end

    def not_found
      render file: Rails.root.join('public', '404.html'), layout: false, status: :not_found
    end

    def rails_admin_controller?
      true
    end
  end
end
