class StandardBuildController < ApplicationController
  def index
    @providers = Provider.all
    @datacenters = []
    @clusters = []
    @datastores = []
    @networks = []
  end

  def find_datacenters
    provider_id = params[:provider_id]
    @provider = Provider.find_by('id = ?',provider_id)
    @provider.connect
    uri="/rest/vcenter/datacenter"
    base_url = @provider.provider_url
    url = base_url+uri
    header = {}
    
    header["Content-Type"]  = 'application/json' 
    header["Accept"] = 'application/json'
    header["vmware-api-session-id"] = @provider.provider_session
    response = HTTParty.get(url, :headers => header ,:verify => false) 
    @datacenters = response["value"]
  end

  def find_cdn
    datacenter = params[:datacenter]
    provider_id = params[:provider_id]
    @provider = Provider.find_by('id = ?',provider_id)
    @provider.connect

    uri_cluster="/rest/vcenter/cluster?filter.datacenters=#{datacenter}"
    uri_datastore="/rest/vcenter/datastore?filter.datacenters=#{datacenter}"
    uri_network="/rest/vcenter/network?filter.datacenters=#{datacenter}"

    base_url = @provider.provider_url
    header = {}
    header["Content-Type"]  = 'application/json' 
    header["Accept"] = 'application/json'
    header["vmware-api-session-id"] = @provider.provider_session

    url = base_url+uri_cluster
    response = HTTParty.get(url, :headers => header ,:verify => false) 
    @clusters = response["value"]

    url = base_url+uri_datastore
    response = HTTParty.get(url, :headers => header ,:verify => false) 
    @datastores = response["value"]

    url = base_url+uri_network
    response = HTTParty.get(url, :headers => header ,:verify => false) 
    @networks = response["value"]

    @cdn = {
      :clusters => @clusters,
      :datastores => @datastores,
      :networks => @networks
    }

  end

  def find_clusters
    provider_id = params[:provider_id]
    @provider = Provider.find_by('id = ?',provider_id)
    @provider.connect
    
    datacenter = params[:datacenter]
    uri="/rest/vcenter/cluster?filter.datacenters=#{datacenter}"
    base_url = @provider.provider_url
    url = base_url+uri
    header = {}
    
    header["Content-Type"]  = 'application/json' 
    header["Accept"] = 'application/json'
    header["vmware-api-session-id"] = @provider.provider_session
    response = HTTParty.get(url, :headers => header ,:verify => false) 
    @clusters = response["value"]
  end

  def find_datastores
    datastore = params[:datastore]
    uri="/rest/vcenter/datastore?filter.datacenters=#{datacenter}"
    base_url = @provider.provider_url
    url = base_url+uri
    header = {}
    
    header["Content-Type"]  = 'application/json' 
    header["Accept"] = 'application/json'
    header["vmware-api-session-id"] = @provider.provider_session

    @datastores = HTTParty.get(url, :headers => header ,:verify => false)
  end

  def find_networks
    network = params[:network]
    uri="/rest/vcenter/network?filter.datacenters=#{datacenter}"
    base_url = @provider.provider_url
    url = base_url+uri
    header = {}
    
    header["Content-Type"]  = 'application/json' 
    header["Accept"] = 'application/json'
    header["vmware-api-session-id"] = @provider.provider_session

    @networks = HTTParty.get(url, :headers => header ,:verify => false)
  end

  def create

  end




end
