class FacebookEvents
  @queue = :facebook_events

  class << self
    def perform
      Project.active.each do |project|
        Cacheable.update(project.name, :facebook_events)
      end
    end
  end
end