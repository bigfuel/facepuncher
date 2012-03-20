require "minitest_helper"

describe Project do
  describe "A project" do
    before do
      @project = Fabricate(:project, name: "bf_project_test")
    end

    it "should have validations" do
      new_project = Fabricate.build(:project)
      new_project.must have_valid(:name).when("new_project")
      new_project.wont have_valid(:name).when(@project.name)
      new_project.wont have_valid(:name).when("")

      @project.must have_valid(:repo).when("git@bitbucket.org:bigfuel/bf_project_test.git")
      @project.wont have_valid(:repo).when("")
    end

    it "must be valid" do
      @project.must_be :valid?
    end

    it "starts in a inactive state" do
      @project.must_be :inactive?
    end

    it "should be activated" do
      @project.activate
      @project.must_be :active?
    end

    it "should be deactivated" do
      @project.activate
      @project.deactivate
      @project.must_be :inactive?
    end

    it "touched, should save" do
      @project.touch.must_equal @project.save
    end

    it "returns name" do
      @project.to_param.must_equal "bf_project_test"
    end

    it "find project by name" do
      Project.find_by_name("bf_project_test").must_equal @project
    end

    it "must have a master branch release" do
      @project.releases.count.must_equal 1
      release = @project.releases.first
      release.branch.must_equal "master"
    end

    it "must deploy the release" do
      Resque.size(:deploy_project).must_equal 1
    end
  end

  describe "An unperisted project" do
    before do
      @project = Fabricate.build(:project, name: 'Shabuttie')
    end

    it "returns the project name on to_param" do
      @project.to_param.must_equal 'Shabuttie'
    end
  end

  describe "Projects" do
    before do
      @inactive = Array.new
      @active = Array.new

      @inactive << Fabricate(:project)

      p = Fabricate(:project)
      p.deactivate
      @inactive << p

      p = Fabricate(:project)
      p.activate
      @active << p

      p = Fabricate(:project)
      p.activate
      @active << p
    end

    it 'should find all active projects' do
      (Project.active.entries - @active).must_be_empty
    end

    it 'should find all inactive projects' do
      (Project.inactive.entries - @inactive).must_be_empty
    end
  end
end