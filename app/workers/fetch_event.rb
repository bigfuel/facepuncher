class FetchEvent
  include Sidekiq::Worker

  def perform(project_name, event_name)
    FacebookGraph::Event.update project_name, event_name
  end

  def self.queue_all
    Project.active.each do |project|
      project.facebook_events.each do |event|
        FetchEvent.perform_async project.name, event.name
      end
    end
  end
end