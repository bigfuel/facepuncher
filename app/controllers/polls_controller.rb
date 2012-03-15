class PollsController < ApplicationController
  respond_to :json

  def vote
    poll = @project.polls.active.find(params[:id])
    poll.vote(params['choice']['id'])

    render json: poll.to_json
  end

  def show
    @poll = @project.polls.active.find(params[:id])

    respond_with @project, @poll
  end
end
