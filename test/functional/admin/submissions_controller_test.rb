require 'minitest_helper'

describe Admin::SubmissionsController do
  describe "index action" do
    it "render index template" do
      get :index
      assert_template 'index'
    end
  end

  describe "new action" do
    it "render new template" do
      get :new
      assert_template 'new'
    end
  end

  describe "edit action" do
    it "render edit template" do
      get :edit, id: Admin::Submissions.first
      assert_template 'edit'
    end
  end
end
