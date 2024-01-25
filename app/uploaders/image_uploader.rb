class ImageUploader < Shrine

  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)
    { thumbnail: magick.resize_to_limit!(200, 250) }
  end

  Attacher.promote_block do
    PromoteJob.perform_now(self.class.name, record.class.name, record.id, name, file_data)
  end

end
