class Provider < ApplicationRecord

	def connect 
	    url = self.provider_url + "/rest/com/vmware/cis/session?~action=get"
		response = HTTParty.post(url, 
		    headers: { 'vmware-api-session-id' => self.provider_session ,'Content-Type' => 'application/json', 'Accept' => 'application/json'},
		    verify: false
		     )
		if ( response["value"]["user"].nil? )
			url = self.provider_url + "/rest/com/vmware/cis/session"
			response = HTTParty.post(url, 
			    basic_auth: { username: self.provider_user, password: self.provider_password },
			    headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json'},
			    verify: false
			     )
			self.provider_session = response["value"]
		end 
	end

end
