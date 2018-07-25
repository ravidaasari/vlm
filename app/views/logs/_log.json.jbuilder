json.extract! log, :id, :user, :browser, :ip_address, :controller, :action, :params, :note, :created_at, :updated_at
json.url log_url(log, format: :json)
