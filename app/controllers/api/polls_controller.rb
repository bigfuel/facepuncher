class Api::PollsController < ApplicationController
  before_filter :load_project, :check_for_project

  respond_to :json, :xml

  def index
    @polls = @project.polls.page(params[:page])

    respond_with :api, @project, @polls
  end

  def vote
    poll = @project.polls.active.find(params[:id])
    poll.vote(params['choice']['id'])

    respond_with :api, @project, @poll
  end

  def show
    @poll = @project.polls.find(params[:id])

    respond_with :api, @project, @poll
  end

  def create
    @poll = @project.polls.new(params[:poll])

    if @poll.save
      @poll.move_to_top
    end

    respond_with :api, @project, @poll
  end
end
