CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',       # required
    :aws_access_key_id      => 'AKIAJ7LLMIQJP57FAP3Q',       # required
    :aws_secret_access_key  => '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',
	:region => 'us-east-1'
  }
  config.fog_directory  = 'narrately.com'                     # required
  config.s3_access_key_id = 'AKIAJ7LLMIQJP57FAP3Q'
      config.s3_secret_access_key = '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'
	  config.s3_bucket = 'narrately.com'
    
  
end