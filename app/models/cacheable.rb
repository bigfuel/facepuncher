module Cacheable
  module Errors
    class Error < StandardError; end
    class NotImplementedError < Errors::Error; end
  end

  class << self
    def update(project_name, model)
      project = Project.find_by_name(project_name)
      key = model.to_s.tableize
      begin
        results = project.send(key).cached_results
        Rails.cache.write(cache_key(project.name, key), results)
      rescue NoMethodError
        raise Errors::NotImplementedError, "You must define a #cached method."
      end
    end

    def read(project_name, model)
      project = Project.find_by_name(project_name)
      key = model.to_s.tableize
      Rails.cache.read(cache_key(project.name, key))
    end

    def get(project_name, model)
      results = read(project_name, model)
      unless results
        update(project_name, model)
        results = read(project_name, model)
      end
      results
    end

    private
    def cache_key(project_name, key)
      "projects:#{project_name}:#{key}"
    end
  end
end