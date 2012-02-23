require "test_helper"

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

class ProjectCacheableTest < ActiveSupport::TestCase
  setup do
    @project = Fabricate(:project)
    @widget = @project.widgets.new(name: Faker::Name.first_name)

    5.times do
      e = @widget.save
    end
  end

  context ProjectCacheable do
    should "enqueue the project cache after save" do
      assert_equal 5, Resque.size(:project_cache)
    end

    should "enqueue the project cache after destroy" do
      @project.widgets.last.destroy
      assert_equal 6, Resque.size(:project_cache)
    end
  end

  context Cacheable do
    should "update the cache if #cached_results method exist" do
      Cacheable.update(@project.name, :widgets)
      assert_equal @project.widgets, Cacheable.read(@project.name, :widgets)
    end

    should "return nil if the cache being read doesn't exist" do
      assert_equal nil, Cacheable.read(@project.name, :widgets)
    end

    should "get the cache if cache does not exist" do
      assert_equal @project.widgets, Cacheable.get(@project.name, :widgets)
    end

    should "raise an exception if #cached method does not exist when calling .get" do
      assert_raise Cacheable::Errors::NotImplementedError do
        Cacheable.get(@project.name, :non_cacheable_widgets)
      end
    end

    should "raise an exception if #cached method does not exist when calling .update" do
      assert_raise Cacheable::Errors::NotImplementedError do
        Cacheable.update(@project.name, :non_cacheable_widgets)
      end
    end
  end
end