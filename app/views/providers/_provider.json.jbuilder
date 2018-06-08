json.extract! provider, :id, :provider_name, :provider_type, :provider_url, :provider_user, :provider_password, :provider_session, :created_at, :updated_at
json.url provider_url(provider, format: :json)
