require 'minitest_helper'

describe Post do
  it "should have validations" do
    post = Fabricate.build(:post)
    post.must have_valid(:title)
    post.wont have_valid(:title).when(nil)

    post.must have_valid(:content)
    post.wont have_valid(:content).when(nil)

    post.must have_valid(:url)
    post.wont have_valid(:url).when(nil)
  end

  describe "A post" do
    before do
      @project = Fabricate(:project)
      @post = Fabricate(:post)
    end

    it "should be valid" do
      @post.must_be :valid?
    end

    it "is approved" do
      @post.approve
      @post.must_be :approved?
    end

    it "is denied" do
      @post.deny
      @post.must_be :denied?
    end

    it "starts in a pending state" do
      @post.must_be :pending?
    end
  end

  describe "Posts" do
    before do
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

    it "finds all pending" do
      (Post.pending.entries - @pending).must_be_empty
    end

    it "finds all denied" do
      (Post.denied.entries - @denied).must_be_empty
    end

    it "finds all approved" do
      (Post.approved.entries - @approved).must_be_empty
    end
  end
end
