require "minitest_helper"

Project.class_eval do
  has_many :widgets
  has_many :non_cacheable_widgets
end

class Widget
  include Mongoid::Document
  include ProjectCacheable

  belongs_to :project

  field :name, type: String

  def self.cached_results
    order_by(:name, :desc)
  end
end

class NonCacheableWidget
  include Mongoid::Document
  belongs_to :project
end

describe ProjectCacheable do
  before do
    @project = Fabricate(:project)
    @widget = @project.widgets.new(name: Faker::Name.first_name)

    5.times do
      e = @widget.save
    end
  end

  describe "Project cache" do
    it "enqueues the project cache after save" do
      Resque.size(:project_cache).must_equal 5
    end

    it "enqueues the project cache after destroy" do
      @project.widgets.last.destroy
      Resque.size(:project_cache).must_equal 6
    end
  end

  describe "Cacheable" do
    it "updates the cache if #cached_results method exist" do
      Cacheable.update(@project.name, :widgets)
      Cacheable.read(@project.name, :widgets).must_equal @project.widgets
    end

    it "returns nil if the cache being read doesn't exist" do
      Cacheable.read(@project.name, :widgets).must_be_nil
    end

    it "gets the cache if cache does not exist" do
      Cacheable.get(@project.name, :widgets).must_equal @project.widgets
    end

    it "raises an exception if #cached method does not exist when calling .get" do
      lambda { Cacheable.get(@project.name, :non_cacheable_widgets) }.must_raise Cacheable::Errors::NotImplementedError
    end

    it "raises an exception if #cached method does not exist when calling .update" do
      lambda { Cacheable.update(@project.name, :non_cacheable_widgets) }.must_raise Cacheable::Errors::NotImplementedError
    end
  end
end