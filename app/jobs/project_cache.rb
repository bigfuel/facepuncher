class ProjectCache
  @queue = :project_cache

  class << self
    def perform(project_name, model)
      Cacheable.update(project_name, model)
    end
  end
end