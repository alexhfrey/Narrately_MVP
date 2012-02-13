if Rails.env.production?  
Rails.application.config.middleware.use OmniAuth::Builder do
	provider :facebook, '333924066629604', '0cc1164e4805256031da55dbb9740125' 	
	provider :identity
  
	{:client_options => {:ssl => {:ca_path => '/usr/lib/ssl/certs/ca-certificates.crt'}}}
	end
else
Rails.application.config.middleware.use OmniAuth::Builder do
	provider :facebook, '173481316095568', 'a106992ae684af007857e95876a8172a', :scope => 'email, offline_access'  
	provider :twitter, '1NaBaXI8sNsnACN0AfzNhg', '4CSeBQJdTRf5qsY37wNmglMriSifAROovaCwb9ENXDk'
	provider :identity
  
	end
end



	
	