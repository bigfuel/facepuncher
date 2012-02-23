# encoding: utf-8

class CaptionUploader < ImageUploader
  process :caption

  def caption
    manipulate! do |img|
      img.combine_options do |c|
        c.font "helvetica-bold"
        c.fill "white"
        c.pointsize 26
        c.gravity "center"
        c.draw "text 0,300 '\u201C#{sanitize(model.text)}\u201D\'"
        c.font "helvetica-italic"
        c.pointsize 18
        c.draw "text 0,325 '#{sanitize(model.subheading)}'"
      end
      img = yield(img) if block_given?
      img
    end
  end

  # Override the filename of the uploaded files:
  def filename
    # "#{Time.current.to_i.to_s}.#{file.extension}" if original_filename
    "I_Like_Cadillac_Because.#{file.extension}" if original_filename
  end

  protected
  def sanitize(text)
    text.gsub(/['"]/, "\\\\'")
  end
end
