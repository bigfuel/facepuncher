class SignupsController < ApplicationController
  def create
    @signup = @project.signups.new(params[:signup])
    params[:signup].each do |k, v|
      @signup[k] = v unless @signup.respond_to?(k)
    end
    respond_to do |format|
      if @signup.save
        @signup.complete if @signup[:opt_out]
        format.json { render json: @signup }
      else
        format.json { render json: @signup.errors, status: :unprocessable_entity }
      end
    end
  end
end