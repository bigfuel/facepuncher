class SignupsController < ApplicationController
  respond_to :json

  def create
    @signup = @project.signups.new(params[:signup])
    params[:signup].each do |k, v|
      @signup[k] = v unless @signup.respond_to?(k)
    end

    if @signup.save
      @signup.complete if @signup[:opt_out]
    end
    respond_with @project, @signup
  end
end