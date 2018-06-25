class Provider < ApplicationRecord
has_many :catalogs, :dependent => :destroy
	 def connect
	    url = self.provider_url + "/rest/com/vmware/cis/session?~action=get"
	    auth = { username: self.provider_user, password: self.provider_password }
	    header = {}
	    header["Content-Type"]  = 'application/json' 
	    header["Accept"] = 'application/json'
	    header["vmware-api-session-id"] = self.provider_session

	    begin
	      response = HTTParty.post(url, headers: header ,verify: false)
	        case response.code
	            when 200
	            	# Current Session Active ... hence no work.
	            	puts "Already logged in as #{response["value"]["user"]}"
	            	puts response
	            	self.provider_session
	            
	            when 401
	            	# Session expired or invalid session-id
					url = self.provider_url + "/rest/com/vmware/cis/session"
					response = HTTParty.post(url, basic_auth: auth, headers: header, verify: false)
					self.provider_session = response["value"]
					self.save

	            when 404
	            	# Session expired or invalid session-id
					url = self.provider_url + "/rest/com/vmware/cis/session"
					response = HTTParty.post(url, basic_auth: auth, headers: header, verify: false)
					self.provider_session = response["value"]
					self.save
	            else 
	            	# Other status of responses.
	            	puts "response code - #{response.code}"
	                puts "response value - #{response['value']}"
	        end

	    rescue HTTParty::Error => error
	    	puts "Our HTTP Error"
	    	puts error.inspect
	    	return error
	    
	    rescue StandardError => error
	    	puts "Our Standard Error"
	        puts error.inspect
	        return error
	    end
	 end
	

	def connect_ws
        host = self.provider_url.slice(8..self.provider_url.length)
        user = self.provider_user
        password = self.provider_password
        opts = { host: host, user: user, password: password, insecure: true } 
        return RbVmomi::VIM.connect opts
	end 

	def disconnect
	    url = self.provider_url + "/rest/com/vmware/cis/session"
	    auth = { username: self.provider_user, password: self.provider_password }
	    header = {}
	    header["Content-Type"]  = 'application/json' 
	    header["Accept"] = 'application/json'
	    header["vmware-api-session-id"] = self.provider_session

	    begin
	      response = HTTParty.delete(url, headers: header ,verify: false)
	        case response.code
	            when 200
	            	# Current Session Active ... hence no work.
	            	puts "Already logged in as #{response["value"]["user"]}"
	            	puts response
					self.provider_session = "Session Disconnected"
					self.save
						            
	            when 401
	            	# Session expired or invalid session-id
					url = self.provider_url + "/rest/com/vmware/cis/session"
					response = HTTParty.delete(url, headers: header, verify: false)
					self.provider_session = "Session Disconnected"
					self.save

	            when 404
	            	# Session expired or invalid session-id
					url = self.provider_url + "/rest/com/vmware/cis/session"
					response = HTTParty.delete(url, headers: header, verify: false)
					self.provider_session = "Session Disconnected"
					self.save
	            else 
	            	# Other status of responses.
	            	puts "response code - #{response.code}"
	                puts "response value - #{response['value']}"
	        end

	    rescue HTTParty::Error => error
	    	puts "Our HTTP Error"
	    	puts error.inspect
	    	return error
	    
	    rescue StandardError => error
	    	puts "Our Standard Error"
	        puts error.inspect
	        return error
	    end
	 end
	
end
