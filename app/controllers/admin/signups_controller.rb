require 'csv'

class Admin::SignupsController < AdminController
  respond_to :html, :json
  respond_to :csv, only: :index

  def index
    respond_with @signups do |format|
      format.csv do
        @signups = @project.signups
        csv_string = CSV.generate do |csv|
          csv << [
          "Date",
          "First Name",
          "Last Name",
          "Address",
          "City",
          "State",
          "Zip Code",
          "Email"
          ]
          @signups.each do |signup|
            csv << [
            signup.created_at,
            signup.first_name,
            signup.last_name,
            signup.address,
            signup.city,
            signup.state_province,
            signup.zip_code,
            signup.email
            ]
          end
        end
        render text: csv_string
      end
    end
  end

  def new
    @signup = @project.signups.new
  end

  def edit
    @signup = @project.signups.find(params[:id])
  end

  def show
  end
  
  def create
    @signup = @project.signups.new(params[:signup])
    @signup.save
    respond_with @signup, location: [:admin, @project, @signup]
  end


  def update
    @signup = @project.signups.find(params[:id])
    @signup.update_attributes(params[:signup])
    respond_with @signup, location: [:admin, @project, @signup]
  end

  def destroy
    @signup = @project.signups.find(params[:id])
    @signup.destroy
    
    respond_with @signup, location: admin_project_signups_url do |format|
      format.json { render json: '{ "status":"success" }', status: :ok }
    end
  end
end
