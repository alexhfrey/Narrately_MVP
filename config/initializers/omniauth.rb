Rails.application.config.middleware.use OmniAuth::Builder do
	provider :facebook, '333924066629604', '0cc1164e4805256031da55dbb9740125' 
	{:client_options => {:ssl => {:ca_path => "C:\RailsInstaller\Git\ssl\certs"}}}
end
	
	