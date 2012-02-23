class Admin::ChoicesController < AdminController
  def destroy
    poll = @project.polls.find(params[:poll_id])
    choice = poll.choices.find(params[:id])
    choice.destroy

    respond_to do |format|
      format.html { redirect_to edit_admin_project_poll_url(@project, poll) }
      format.json { head :ok }
    end
  end
end