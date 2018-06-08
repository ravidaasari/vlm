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
    provider = Provider.find_by('id = ?',provider_id)
    provider.connect
    uri="/rest/vcenter/datacenter"
    base_url = provider.provider_url
    url = base_url+uri
    header = {}
    
    header["Content-Type"]  = 'application/json' 
    header["Accept"] = 'application/json'
    header["vmware-api-session-id"] = provider.provider_session

    @datacenters = HTTParty.get(url, :headers => header ,:verify => false) 

  end

  def find_clusters
  end

  def find_datastores
  end

  def find_networks
  end

  def create

  end




end
