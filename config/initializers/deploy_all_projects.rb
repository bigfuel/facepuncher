Rails.application.config.after_initialize do
  if Rails.env.development?
    DeployProject.queue_active
  end
end