namespace :carrierwave do
  task migrate: :environment do
    Image.all.entries.each do |i|
      i.rename(:file_filename, :file)
    end
    Wallpaper.all.entries.each do |w|
      w.rename(:image_filename, :image)
    end
    Caption.all.entries.each do |c|
      c.rename(:image_filename, :image)
    end
    Video.all.entries.each do |v|
      v.rename(:screencap_filename, :screencap)
    end
    Submission.all.entries.each do |s|
      w.rename(:photo_filename, :photo)
    end
    Poll.all.entries.each do |p|
      p.choices.each do |c|
        c.rename(:image_filename, :image)
      end
    end
  end
end