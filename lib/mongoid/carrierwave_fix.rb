module Mongoid::CarrierwaveFix
  extend ActiveSupport::Concern

  included do
    after_destroy :delete_images!
  end

  def delete_images!
    self.images.each do |image|
      image.remove_image!
    end

    self.polls.each do |poll|
      poll.choices.each do |image|
        image.remove_image!
      end
    end

    self.posts.each do |image|
      image.remove_image!
    end

    self.videos.each do |video|
      video.remove_screencap!
    end

    self.submissions.each do |submission|
      submission.remove_photo!
    end
  end
end