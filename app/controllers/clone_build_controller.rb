class CloneBuildController < ApplicationController
  
  def index
    @providers = Provider.all
    @datacenters = []
    @clusters = []
    @datastores = []
    @networks = []
    @vms = []
    @folders = []
    @vms_folder = []
    @resource_pool = []
    @tags = []
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
    end  
  end

  def find_tags(provider_id,network_id)
    provider_id = params[:provider]
    network_id = params[:network]
    @provider = Provider.find_by('id = ?',provider_id)
    @provider.connect

    header = {}
    header["Content-Type"]  = 'application/json' 
    header["Accept"] = 'application/json'
    header["vmware-api-session-id"] = @provider.provider_session
      
    data = {"object_id" => {:type => "Network", :id => network_id}}
    object_id = {}
    object_id["type"] = 'Network'
    object_id["id"] = network_id
    uri="/rest/com/vmware/cis/tagging/tag-association?~action=list-attached-tags"
    base_url = @provider.provider_url
    url = base_url+uri
    
    response = HTTParty.post(url, :headers => header ,:verify => false,:body => data.to_json) 
    @tags = response["value"]
    puts @tags

    hash_response = {}
      @tags.each do |tag|
        uri_tag="/rest/com/vmware/cis/tagging/tag/id:#{tag}"
        base_url = @provider.provider_url
        url_tag = base_url+uri_tag
        response_tag = HTTParty.get(url_tag, :headers => header ,:verify => false) 
        puts response_tag
        hash_response[response_tag["value"]["description"]]=response_tag["value"]["name"]
       
    end  
    return hash_response
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

  def find_resource_pool(provider_id,cluster)
    
    @provider = Provider.find_by('id = ?',provider_id)
    @provider.connect
    uri = "/rest/vcenter/cluster/#{cluster}"
    base_url = @provider.provider_url
    url = base_url+uri
    header = {}
    header["Content-Type"]  = 'application/json' 
    header["Accept"] = 'application/json'
    header["vmware-api-session-id"] = @provider.provider_session
    response = HTTParty.get(url, :headers => header ,:verify => false)
    puts response["value"]["resource_pool"]
    @resource_group = response["value"]["resource_pool"]

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

  def get_ips(my_subnet)
    @my_subnet = my_subnet
    
    infoblox_user = "svc.coreinfra_robot"
    infoblox_password = "Vmware@123"
    infoblox_url = "https://10.28.115.195"

    auth = { username: infoblox_user, password: infoblox_password }
    header = {}
    header["Content-Type"]  = 'application/json' 
    header["Accept"] = 'application/json'

    url = infoblox_url + "/wapi/v2.5/network?network=#{my_subnet}&_return_as_object=1"
    puts url
    response = HTTParty.get(url, basic_auth: auth, headers: header, verify: false)
    puts response
    puts response["result"]
    network_reference = response["result"][0]["_ref"]

    # body = '{"num" => 5}'
    url1 = infoblox_url + "/wapi/v2.5/" + network_reference + "?_function=next_available_ip&_return_as_object=1"
    response1 = HTTParty.post(url1, basic_auth: auth, headers: header, verify: false)
    puts response1
    return response1["result"]["ips"][0]

  end

  def register_host(my_ip_address, my_target_vm)
    ip_address = my_ip_address
    my_target_vm = my_target_vm + ".vmware.com"
    puts ip_address
    puts my_target_vm

    infoblox_user = "svc.coreinfra_robot"
    infoblox_password = "Vmware@123"
    infoblox_url = "https://10.28.115.195"

    auth = { username: infoblox_user, password: infoblox_password }
    header = {}
    header["Content-Type"]  = 'application/json' 
    header["Accept"] = 'application/json'

    url = "https://10.28.115.195/wapi/v2.5/record:host"
    # body = {:name=>"#{my_target_vm}", :ipv4addrs=>[{:ipv4addr=>"#{ip_address}"}], :view=>"default", :extattrs=>{:"Tenant ID"=>{:value=>"1011"}, :"Cloud API Owned"=>{:value=>"False"}, :"CMP Type"=>{:value=>"vCO/vCAC"}}}
    # body =  {"name" => "#{my_target_vm}","ipv4addrs"=> [{"ipv4addr"=> "#{ip_address}"}],"view"=> "default","extattrs"=> {"Tenant ID"=> {"value"=> "1011"},"Cloud API Owned"=> {"value"=> "False"},"CMP Type"=> {"value"=> "vCO/vCAC"}}}

    body = {"name":my_target_vm,"ipv4addrs":[{"ipv4addr":ip_address}],"view":"default","extattrs":{"Tenant ID":{"value":"1011"},"Cloud API Owned":{"value":"False"},"CMP Type":{"value":"vCO/vCAC"}}}
    response_dns = HTTParty.post(url, basic_auth: auth, headers: header, body: body.to_json, verify: false)
    puts response_dns


  end


  def create
    my_datastore = params[:datastore_name]
    my_datacenter = params[:datacenter_name]
    my_network = params[:network_name]
    # my_dnsServer = params[:dnsServer]
    my_numCPUs = params[:numCPUs]
    my_memoryMB = params[:memoryMB]
    my_vlan = params[:vlan]    
    # my_netmask = params[:netmask]
    # my_gateway = params[:gateway]
    my_source_vm = params[:source_vm_name]
    my_target_vm = params[:target_vm]
    # @target_vm_name = params[:target_vm_name]
    # my_ip_address = params[:ip_address]
    my_annotation = params[:annotation]
    provider_id = params[:provider]
    my_cluster = params[:cluster]
    network_id = params[:network]
    
    my_net_details = find_tags(provider_id,network_id)
    puts my_net_details
    my_netmask = my_net_details["netmask"]
    my_gateway = my_net_details["gateway"]
    my_dnsServer = my_net_details["dns"]
    my_subnet = my_net_details["subnet"]

    vc_obj = RbVmomi::VIM
    provider = Provider.find_by('id = ?',provider_id)
    vc = provider.connect_ws
    dc = vc.serviceInstance.find_datacenter(my_datacenter) or abort "datacenter not found"
    vm = dc.find_vm(my_source_vm) or abort "VM not found"
                
    my_ip_address = get_ips(my_subnet)
    register_host(my_ip_address, my_target_vm)

    relocateSpec = vc_obj.VirtualMachineRelocateSpec({
      datastore: params[:datastore],
      pool: find_resource_pool(provider_id,my_cluster)
    })


    identity = vc_obj.CustomizationLinuxPrep({
        hostName: vc_obj.CustomizationFixedName(name: my_target_vm),
        domain:   "vmware.com"
      }) 
      
      global_ip_settings = vc_obj.CustomizationGlobalIPSettings({
        dnsServerList: [my_dnsServer],
        dnsSuffixList: ["vmware.com"]
      })
      
      ip_address      = vc_obj.CustomizationFixedIp(ipAddress: my_ip_address)
      ip_settings     = vc_obj.CustomizationIPSettings ip: ip_address 
      ip_settings.subnetMask = my_netmask
      ip_settings.gateway = [ my_gateway ]
      adapter_mapping = vc_obj.CustomizationAdapterMapping adapter: ip_settings 
      
      customize_spec  = vc_obj.CustomizationSpec({
        identity:         identity,
        nicSettingMap:    [adapter_mapping],
        globalIPSettings: global_ip_settings
      })
      
      
      target_config = vc_obj.VirtualMachineConfigSpec({
               annotation: my_annotation,
               memoryMB: my_memoryMB,
               numCPUs: my_numCPUs,
               deviceChange: [
         {
          :operation => :edit,
          :device => vc_obj.VirtualVmxnet3(
            :key => 4000,
            :deviceInfo => {
              :label => 'Network Adapter 1',
              :summary => my_network
            },
              :backing => vc_obj.VirtualEthernetCardNetworkBackingInfo(
              :deviceName => my_network
            ),
            :addressType => 'generated'

          )
        }
      ],
      })


      spec = vc_obj.VirtualMachineCloneSpec(:location => relocateSpec,
                                         :customization => customize_spec,
                                         :config => target_config,
                                         :powerOn => true,
                                         :template => false)

      @new_vm = vm.CloneVM_Task(:folder => vm.parent, :name => my_target_vm, :spec => spec).wait_for_completion
  end



end
