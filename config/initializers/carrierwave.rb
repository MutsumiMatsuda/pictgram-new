CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS',
    #aws_access_key_id: ENV['AWS_S3_ACCESS_KEY'],
    #aws_secret_access_key: ENV['AWS_S3_SECRET_KEY'],
    #region: ENV['AWS_S3_REGION'],
    aws_access_key_id: 'AKIAJQO7SHRYUD5UAL5A',
    aws_secret_access_key: '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',
    region: 'ap-northeast-1',
    path_style: true
  }
  config.fog_public = true # public-read

  config.remove_previously_stored_files_after_update = false

  #config.fog_directory = ENV['AWS_S3_BUCKET']
  #config.asset_host = ENV['AWS_S3_URL']
  config.fog_directory = 'mimg4tmat-pictgramnew'
  config.asset_host = 'https://s3-ap-northeast-1.amazonaws.com/img4tmat-pictgramnew'

end
# 文字化け対策
CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/
