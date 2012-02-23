module ProjectCacheable
  extend ActiveSupport::Concern

  included do
    after_save :enqueue_cache
    after_destroy :enqueue_cache
  end

  def enqueue_cache
    Resque.enqueue(ProjectCache, self.project.name, self.class.name.underscore.to_sym)
  end
end