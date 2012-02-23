require 'test_helper'

class PostTest < ActiveSupport::TestCase
  should validate_presence_of(:title)
  should validate_presence_of(:content)
  should validate_presence_of(:url)

  context Post do
    setup do
      @project = Fabricate(:project)
      @post = Fabricate(:post)
    end

    should "be valid" do
      assert @post.valid?
    end

    should "approve a post" do
      @post.approve
      assert @post.approved?
    end

    should "deny a post" do
      @post.deny
      assert @post.denied?
    end

    should "start in a pending state" do
      assert @post.pending?
    end

    should "return cached_results" do
      results = @project.posts.where(state: "approved").order_by([:created_at, :asc]).entries
      assert_equal results, @project.posts.cached_results
    end

    should "init_list" do
      flunk
    end
  end

  context "Posts" do
    setup do
      @pending = Array.new
      @denied = Array.new
      @approved = Array.new

      @pending << Fabricate(:post)

      2.times do
        e = Fabricate(:post)
        e.deny
        @denied << e
      end

      3.times do
        e = Fabricate(:post)
        e.approve
        @approved << e
      end
    end

    should "find all pending posts" do
      posts = Post.pending
      assert_equal 1, posts.count
      assert_empty @pending - posts
    end

    should "find all denied posts" do
      posts = Post.denied
      assert_equal 2, posts.count
      assert_empty @denied - posts
    end

    should "find all approved posts" do
      posts = Post.approved
      assert_equal 3, posts.count
      assert_empty @approved - posts
    end
  end
end
