require 'minitest_helper'

describe Deploy do
  before do
    @project = Fabricate(:project)
    @release = Fabricate(:release, project: @project, live_date: Time.current)
  end

  describe "clones a repo" do
    before do
      @project_path = Deploy::PROJECTS_PATH.join(@project.name)
      FileUtils.rm_rf(@project_path, secure: true)
    end

    it "successfully" do
      Deploy.clone_repo(@project_path, @project.repo, @release.branch)[0].must_equal 0
      Grit::Repo.new(@project_path).must_be_instance_of Grit::Repo
    end

    it "unsuccessfully" do
      lambda { Deploy.clone_repo(@project_path, nil, @release.branch) }.must_raise Grit::Git::CommandFailed
      lambda { Deploy.clone_repo(@project_path, "git@git.example.com/example.git", @release.branch) }.must_raise Grit::Git::CommandFailed
      lambda { Grit::Repo.new(@project_path) }.must_raise Grit::InvalidGitRepositoryError
    end
  end

  it "copy assets to rails asset projects path" do
    skip
  end

  it "compiles assets" do
    skip
  end

  it "generates views" do
    skip
  end

  it "deploys active projects" do
    @project.activate

    if @project.active?
      DeployProject.queue_active
    end

    Sidekiq::Extensions::DeployProject.jobs.size
    Sidekiq::Extensions::DeployProject.jobs.size.must_equal 1
  end

  it "queues unique jobs" do
    @project.activate

    3.times do
      DeployProject.perform_async @project.name
    end

    Sidekiq::Extensions::DeployProject.jobs.size.must_equal 1
  end
end
