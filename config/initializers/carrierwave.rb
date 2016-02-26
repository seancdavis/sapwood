CarrierWave.configure do |config|
  # config.validate_unique_filename = false
  # config.validate_filename_format = false
  # config.storage = :fog
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => Sapwood.config.amazon_aws.access_key_id,
    :aws_secret_access_key  => Sapwood.config.amazon_aws.secret_access_key,
    :region                 => 'us-east-1',
  }
  config.fog_directory  = Sapwood.config.amazon_aws.bucket
  config.fog_public     = true
  config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}  # optional, defaults to {}
end
