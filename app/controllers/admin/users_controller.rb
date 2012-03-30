class Admin::UsersController < AdminController
  def index
    @users = User.page(params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @users }
    end
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end

  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(admin_users_url) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end
end
