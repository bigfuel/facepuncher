class PollsController < ApplicationController
  def vote
    poll = @project.polls.active.find(params[:id])

    respond_to do |format|
      begin
        poll.vote(params['choice']['id'])
        format.html { redirect_to params[:redirect_to] ? "/#{@project.name}/#{params[:redirect_to]}" : :back }
        format.json { render json: poll }
      rescue Exception => e
        logger.error e.message
        format.html { redirect_to '/500.html' }
        format.json { render json: poll.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @poll = @project.polls.active.find(params[:id])
  end
end
