require 'test_helper'

class Admin::SubmissionsControllerTest < ActionController::TestCase
  context "index action" do
    should "render index template" do
      get :index
      assert_template 'index'
    end
  end

  context "new action" do
    should "render new template" do
      get :new
      assert_template 'new'
    end
  end

  context "edit action" do
    should "render edit template" do
      get :edit, id: Admin::Submissions.first
      assert_template 'edit'
    end
  end
end
