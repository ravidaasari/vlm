class Infoblox < ApplicationRecord
	attr_encrypted :infoblox_password,:key => 'This is a key that is 256 bits!!'
end
