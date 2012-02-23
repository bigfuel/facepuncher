require 'csv'

class Admin::SignupsController < AdminController
  def index
    @signups = @project.signups.order_by([sort_column, sort_direction]).page(params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @signups }
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

  def create
    @signup = @project.signups.new(params[:signup])

    respond_to do |format|
      if @signup.save
        format.html { redirect_to [:admin, @project, @signup], notice: 'Signup was successfully created.' }
        format.json { render json: @signup, status: :created, location: @signup }
      else
        format.html { render action: "new" }
        format.json { render json: @signup.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @signup = @project.signups.find(params[:id])
  end

  def update
    @signup = @project.signups.find(params[:id])

    respond_to do |format|
      if @signup.update_attributes(params[:signup])
        format.html { redirect_to [:admin, @project, @signup], notice: 'Signup was successfully updated.' }
        format.json { render json: @signup.as_json(methods: :image_url) }
      else
        format.html { render action: "new" }
        format.json { render json: @signup.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @signup = @project.signups.find(params[:id])
  end

  def destroy
    @signup = @project.signups.find(params[:id])
    @signup.destroy

    respond_to do |format|
      format.html { redirect_to admin_project_signups_url(@project) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end
end
