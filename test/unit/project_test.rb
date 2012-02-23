require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
  should validate_presence_of(:repo)

  context Project do
    setup do
      @project = Fabricate(:project, name: "bf_project_test")
    end

    should "be valid" do
      assert @project.valid?
    end

    should "start in a inactive state" do
      assert @project.inactive?
    end

    should "activate a project" do
      @project.activate
      assert @project.active?
    end

    should "deactivate a project" do
      @project.activate
      @project.deactivate
      assert @project.inactive?
    end

    should "have a unique project name" do
      new_project = Fabricate.build(:project, name: @project.name)
      new_project.save
      refute new_project.valid?
      assert_includes new_project.errors, :name
      assert_includes new_project.errors.messages[:name], 'is already taken'
    end

    should "touch" do
      assert_equal @project.save, @project.touch
    end

    should "return name" do
      assert_equal @project.name, @project.to_param
    end

    should "find project by name" do
      assert_equal @project, Project.find_by_name("bf_project_test")
    end
  end

  context "Unperisted project" do
    setup do
      @project = Fabricate.build(:project, name: 'Shabuttie')
    end

    should "return the project name on to_param" do
      assert_equal 'Shabuttie', @project.to_param
    end
  end

  context 'Projects' do
    setup do
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

    should 'find all active projects' do
      projects = Project.active
      assert_equal 2, projects.count
      assert_empty @active - projects
    end

    should 'find all inactive projects' do
      projects = Project.inactive
      assert_equal 2, projects.count
      assert_empty @inactive - projects
    end
  end
end