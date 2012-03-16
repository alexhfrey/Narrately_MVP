if Rails.env.production?  
Rails.application.config.middleware.use OmniAuth::Builder do
	provider :facebook, '173481316095568', 'a106992ae684af007857e95876a8172a', :scope => 'email, offline_access, read_stream' 	
	provider :twitter, 'aIWATKSZGOQlGcFyFu9yhw', 'mKLlGiCnI6jSE8tHP8xbJgqx8ITXwdCAetuvgYM'
	
  
	{:client_options => {:ssl => {:ca_path => '/usr/lib/ssl/certs/ca-certificates.crt'}}}
	end
else
Rails.application.config.middleware.use OmniAuth::Builder do
	provider :facebook, '242735669136491', 'ea405d01fda59ee513e230cf3a779d0f', :scope => 'email, offline_access, read_stream'  
	provider :twitter, 'aIWATKSZGOQlGcFyFu9yhw', 'mKLlGiCnI6jSE8tHP8xbJgqx8ITXwdCAetuvgYM'
	
  
	end
end



	
	