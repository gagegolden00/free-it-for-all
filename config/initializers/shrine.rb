require 'shrine'
require 'shrine/storage/file_system'
require 'shrine/storage/memory'
require 'shrine/storage/s3'

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
  store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads')
}

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data
Shrine.plugin :restore_cached_data
Shrine.plugin :validation
Shrine.plugin :validation_helpers
Shrine.plugin :derivatives
Shrine.plugin :backgrounding
Shrine.plugin :processing
