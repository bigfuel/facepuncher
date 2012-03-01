require "minitest_helper"

describe "Projects Integration Test" do
  before do
    sign_in Fabricate(:user)
    @project = Fabricate(:project, name: "bf_project_test")
  end

  it "shows project's name" do
    visit admin_project_path(@project)
    page.text.must_include "bf_project_test"
  end
end