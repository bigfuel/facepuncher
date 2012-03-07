class Api::PollsController < ApplicationController
  respond_to :json, :xml

  def index
    @polls = @project.polls.active.page(params[:page])

    respond_with :api, @project, @polls
  end

  def vote
    poll = @project.polls.active.find(params[:id])
    poll.vote(params['choice']['id'])

    respond_with :api, @project, @poll
  end

  def show
    @poll = @project.polls.active.find(params[:id])

    respond_with :api, @project, @poll
  end
end
