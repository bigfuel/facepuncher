require 'fileutils'

class DeployProject
  include Sidekiq::Worker

  def perform(project_name)
    deployable = true

    if Rails.env.development?
      local_path = Pathname.new("#{APP_CONFIG['project_path']}/#{project_name}")
      deployable = false if Dir.exists?(local_path)
    end

    Deploy.perform(project_name) if deployable
  end

  def self.queue_active
    Project.active.each do |project|
      DeployProject.perform_async project.name
    end
  end
end