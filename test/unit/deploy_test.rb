require 'test_helper'

class DeployTest < ActiveSupport::TestCase
  context Deploy do
    setup do
      @project = Fabricate(:project)
      @release = Fabricate(:release, project: @project, live_date: Time.current)
    end

    should "clone the repo" do
      project_path = Deploy::PROJECTS_PATH.join(@project.name)
      FileUtils.rm_rf(project_path, secure: true)

      assert Deploy.clone_repo(project_path, @project.repo, @release.branch)
      assert Grit::Repo.new(project_path)
    end

    should "copy assets to rails asset projects path" do
      flunk
    end

    should "compile_assets" do
      flunk
    end

    should "generate views" do
      flunk
    end

    should "deploy active projects" do
      @project.activate

      if @project.active?
        DeployProject.queue_active
      end

      assert_equal 1, Resque.size(:deploy_project)
    end

    should "queue unique jobs" do
      @project.activate

      3.times do
        Resque.enqueue(DeployProject, @project.name)
      end

      assert_equal 1, Resque.size(:deploy_project)
    end
  end
end
