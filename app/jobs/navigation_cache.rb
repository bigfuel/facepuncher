class NavigationCache
  @queue = :navigation_cache

  class << self
    def perform
      associations = Project.reflect_on_all_associations(:references_many).map(&:name)
      projects = Hash.new
      Project.all.each do |project|
        projects[project.name] = Hash.new
        associations.each do |assoc|
          projects[project.name][assoc] = project.send(assoc).count
        end
      end
      Rails.cache.write("project_association_count", projects)
    end
  end
end