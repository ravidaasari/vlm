class PowerManagementController < ApplicationController
  def index
    @providers = Provider.all
    @datacenters = []
    @vms = []
    @folders = []
    @vms_folder = []
  end

  def find_datacenters
    provider_id = params[:provider_id]
    @provider = Provider.find_by('id = ?',provider_id)
    connection_status = @provider.connect
    if connection_status.nil?
      @datacenters={}
    else
      uri="/rest/vcenter/datacenter"
      base_url = @provider.provider_url
      url = base_url+uri
      header = {}
      
      header["Content-Type"]  = 'application/json' 
      header["Accept"] = 'application/json'
      header["vmware-api-session-id"] = @provider.provider_session
      response = HTTParty.get(url, :headers => header ,:verify => false) 
      @datacenters = response["value"]
      puts @datacenters
    end  
  end

  def find_vms
    vm = params[:source_vm]
    provider_id = params[:provider_id]
    @provider = Provider.find_by('id = ?',provider_id)
    @provider.connect
    
    uri="/rest/vcenter/vm?filter.names=#{vm}"
    base_url = @provider.provider_url
    url = base_url+uri
    header = {}
   
    header["Content-Type"]  = 'application/json' 
    header["Accept"] = 'application/json'
    header["vmware-api-session-id"] = @provider.provider_session
    response = HTTParty.get(url, :headers => header ,:verify => false) 
    @vms = response["value"]
    puts "value of @vms => #{@vms}"
  end

  def find_vms_of_folder
    folder = params[:folders]
    provider_id = params[:provider_id]
    @provider = Provider.find_by('id = ?',provider_id)
    @provider.connect
    
    uri="/rest/vcenter/vm?filter.folders=#{folder}"
    base_url = @provider.provider_url
    url = base_url+uri
    header = {}
   
    header["Content-Type"]  = 'application/json' 
    header["Accept"] = 'application/json'
    header["vmware-api-session-id"] = @provider.provider_session
    response = HTTParty.get(url, :headers => header ,:verify => false)
    @vms_folder = response["value"]

  end

  
    

 	def find_folders
    source_datacenter = params[:source_dc]
    provider_id = params[:provider_id]
    @provider = Provider.find_by('id = ?',provider_id)
    @provider.connect
    uri_folder="/rest/vcenter/folder?filter.datacenters=#{source_datacenter}"
    base_url = @provider.provider_url
    url = base_url+uri_folder
    header = {}
   
    header["Content-Type"]  = 'application/json' 
    header["Accept"] = 'application/json'
    header["vmware-api-session-id"] = @provider.provider_session
    response = HTTParty.get(url, :headers => header ,:verify => false)
    folders_tmp = response["value"]
    folder = folders_tmp.find{|folder| folder["name"] == "vm"}
    folder["name"] = "/"
    @folders = folders_tmp 
    end

    def power
  	provider_id = params[:provider]
  	vm_name = params[:source_vm_name]
  	cmd = params[:cmd]
  	# vm_obj_id = "vm-5057"

  	provider = Provider.find_by('id = ?',provider_id)
    provider.connect

    header = {}
    header["Content-Type"]  = 'application/json' 
    header["Accept"] = 'application/json'
    header["vmware-api-session-id"] = provider.provider_session

    base_url = provider.provider_url

    list_vm = provider.provider_url + "/rest/vcenter/vm?filter.names=#{vm_name}"
    @response = HTTParty.get(list_vm, headers: header, verify: false)
    if @response["value"] == []
    	return @response
    end

    vm_obj_id = @response["value"][0]["vm"]
    puts vm_obj_id

    uri_power_on = "/rest/vcenter/vm/#{vm_obj_id}/power/start"
    uri_power_off = "/rest/vcenter/vm/#{vm_obj_id}/power/stop"
    uri_power = "/rest/vcenter/vm/#{vm_obj_id}/power"
    # uri_destroy = "/rest/vcenter/vm/#{vm_obj_id}"
    uri_reset = "/rest/vcenter/vm/#{vm_obj_id}/power/reset"
    uri_suspend = "/rest/vcenter/vm/#{vm_obj_id}/power/suspend"

    flag = ""

  	case cmd

  		when "power"
  			flag = "get"
  			url = base_url+uri_power

  		when "power_on"
  			flag = "post"
  			url = base_url+uri_power_on
  			

  		when "power_off"
  			flag = "post"
  			url = base_url+uri_power_off

  		when "power_reset"
  			flag = "post"
  			url = base_url+uri_reset

  		when "destroy"
  			flag = "delete"
  			url = base_url+uri_destroy

  		else
  			flag = "exit"
  			puts "Action not defined."
  	end	 	 

  	if flag != "exit"
      puts url
      puts header
	case flag
  		when "post"
  			@response = HTTParty.post(url, headers: header, verify: false)
  			return @response

  		when "get"
  			@response = HTTParty.get(url, headers: header, verify: false)
  			return @response

  		when "delete"
  			@response = HTTParty.delete(url, headers: header, verify: false)
  			return @response

  		end
  	end

  end
end
