desc "This task is called by the Heroku scheduler add-on"

task :ten_minutes => :environment do
  puts "Updating feed..."
  RssFeeds.queue_all
  puts "done."
end

task :hourly => :environment do
  puts "Updating facebook albums..."
  FetchAlbum.queue_all
  puts "done."

  puts "Updating facebook events..."
  FetchEvent.queue_all
  puts "done."
end