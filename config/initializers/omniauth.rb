if Rails.env.production?  
Rails.application.config.middleware.use OmniAuth::Builder do
	provider :facebook, '173481316095568', 'a106992ae684af007857e95876a8172a', :scope => 'email, offline_access, publish_stream' 	
	provider :twitter, 'WNEdEx7qsAEEoewtAhew', '89C7OWZ7dd927RG39ICbYb4VSDARs8B01WrIwWpo'
	
  
	{:client_options => {:ssl => {:ca_path => '/usr/lib/ssl/certs/ca-certificates.crt'}}}
	end
if Rails.env.staging?
	provider :facebook, '333924066629604', '0cc1164e4805256031da55dbb9740125', :scope => 'email, offline_access, publish_stream' 	
	provider :twitter, 'i3wZQHBkVqpZc9TOj1r6XA', 'fQDgDL9UVptHnAmNXZKBrCXcYL6AphfSu1jzWhlW0U'
end  
else

	Rails.application.config.middleware.use OmniAuth::Builder do
	provider :facebook, '333924066629604', '0cc1164e4805256031da55dbb9740125', :scope => 'email, offline_access, publish_stream'  
	provider :twitter, 'im56l5L3UGIDS3kQwJ6JA', 'NLZ7dxXWZImUl9CwJJYqHqEvONpCjOAwNYNljPKbJNo'
end
end



	
	