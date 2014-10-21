require 'fog/aws/storage'

CarrierWave.configure do |config|
  if Rails.env.staging? || Rails.env.production?
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    }
    config.fog_directory  = 'myflix-rich'
    config.fog_public     = false
    config.fog_attributes = {'Cache-Control'=>"max-age=#{365.day.to_i}"}

  else
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end
end
