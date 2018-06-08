json.extract! catalog, :id, :catalog_name, :cpu_min, :cpu_max, :mem_min, :mem_max, :disk_size, :swap_disk, :template_path, :template_name, :created_at, :updated_at
json.url catalog_url(catalog, format: :json)
