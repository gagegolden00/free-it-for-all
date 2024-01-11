class ImageUploader < Shrine

  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)
    { thumbnail: magick.resize_to_limit!(350, 250) }
  end

  Attacher.promote_block do
    PromoteJob.perform_later(self.class.name, record.class.name, record.id, name, file_data)
  end

end
