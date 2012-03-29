class Api::PollsController < ApplicationController
  before_filter :load_project, :check_for_project

  respond_to :json, :xml

  def index
    params[:sort_direction] ||= "asc"
    
    @polls = @project.polls
    @polls = @polls.where(state: params[:state]) if params[:state]
    @polls = @polls.order_by(params[:sort_column], params[:sort_direction]) if params[:sort_column]
    @polls = @polls.page(params[:page])
    @polls = @polls.per(params[:per_page]) if params[:per_page]

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
