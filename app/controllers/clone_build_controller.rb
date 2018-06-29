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


  def create
    my_datastore = params[:datastore_name]
    my_datacenter = params[:datacenter_name]
    my_network = params[:network_name]
    my_dnsServer = params[:dnsServer]
    my_numCPUs = params[:numCPUs]
    my_memoryMB = params[:memoryMB]
    my_vlan = params[:vlan]    
    my_netmask = params[:netmask]
    my_gateway = params[:gateway]
    my_source_vm = params[:source_vm_name]
    my_target_vm = params[:target_vm]
    my_ip_address = params[:ip_address]
    my_annotation = params[:annotation]
    provider_id = params[:provider]
    my_cluster = params[:cluster]
    

    vc_obj = RbVmomi::VIM
    provider = Provider.find_by('id = ?',provider_id)
    vc = provider.connect_ws
    dc = vc.serviceInstance.find_datacenter(my_datacenter) or abort "datacenter not found"
    vm = dc.find_vm(my_source_vm) or abort "VM not found"
                

    #datastore = vc.
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
                                         :powerOn => false,
                                         :template => false)

      @new_vm = vm.CloneVM_Task(:folder => vm.parent, :name => my_target_vm, :spec => spec).wait_for_completion
  end



end
