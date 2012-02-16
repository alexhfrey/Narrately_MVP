CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',       # required
    :aws_access_key_id      => 'AKIAJ7LLMIQJP57FAP3Q',       # required
    :aws_secret_access_key  => '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',       # required

  }
  config.fog_directory  = 'fog'                     # required
  
end