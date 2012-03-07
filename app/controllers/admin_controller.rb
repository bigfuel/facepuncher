class AdminController < ApplicationController
  helper_method :sort_column, :sort_direction
  append_before_filter :authenticate_user!
  layout 'admin'

  protected
  def sort_column
    params[:sort] || "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end