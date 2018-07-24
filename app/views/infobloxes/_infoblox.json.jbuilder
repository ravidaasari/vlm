json.extract! infoblox, :id, :infoblox_url, :infoblox_username, :infoblox_password, :encrypted_infoblox_password, :encrypted_infoblox_password_iv, :created_at, :updated_at
json.url infoblox_url(infoblox, format: :json)
