require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery
  before_filter :load_project
  helper :application

  protected
  def load_project
    @project = params[:project_id] && Project.active.find_by_name(params[:project_id])
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  private
  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    admin_root_path
  end
end