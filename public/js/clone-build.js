var providerHandle = document.getElementById('provider');
var datacenterHandle = document.getElementById('datacenter');
var clusterHandle = document.getElementById('cluster');
var clusterNameHandle = document.getElementById('cluster_name');
var datacenterNameHandle = document.getElementById('datacenter_name');
var tagHandle = document.getElementById('tag');
var tagNameHandle = document.getElementById('tag_name');
var datastoreHandle = document.getElementById('datastore');
var datastoreNameHandle = document.getElementById('datastore_name');
var networkHandle = document.getElementById('network');
var networkNameHandle = document.getElementById('network_name');
var loadingDatacenterHandle = document.getElementById('loading-datacenter');
var loadingSdcHandle = document.getElementById('loading-sdc');
var loadingFolderHandle = document.getElementById('loading-folder');
var loadingVmHandle = document.getElementById('loading-vm');
var loadingClusterHandle = document.getElementById('loading-cluster');
var loadingNetworkHandle = document.getElementById('loading-network');
var loadingDatastoreHandle = document.getElementById('loading-datastore');
var vmHandle = document.getElementById('source_vm');
var TvmHandle = document.getElementById('target_vm');
var vmErrorHandle = document.getElementById('vm_error');
var TvmErrorHandle = document.getElementById('tvm_error');
var memoryHandle = document.getElementById('memoryMB');
var cpuHandle = document.getElementById('numCPUs');
var sourceDcHandle = document.getElementById('source_dc');
var folderHandle = document.getElementById('folders');
var folderNameHandle = document.getElementById('folder_name')
var newClusterHandle = document.getElementById('new_cluster_name');
var vmNameHandle = document.getElementById('source_vm_name');



vmHandle.addEventListener('change', function(){
var xhr = new XMLHttpRequest();
    xhr.open('GET', `/clone_build/find_vms.json?provider_id=${providerHandle.value}&source_vm=${vmHandle.value}`, true);
    

    xhr.onreadystatechange = function(){
      if(xhr.readyState === 4 && xhr.status === 200 ){
          var vmDetails = JSON.parse(xhr.responseText);
          if (JSON.stringify(vmDetails) != '{"vms":[]}') {
               vmErrorHandle.innerHTML = "valid source vm"
               memoryHandle.value = vmDetails["vms"][0]["memory_size_MiB"]
               cpuHandle.value = vmDetails["vms"][0]["cpu_count"]
            }
          else
            {
               vmErrorHandle.innerHTML = "invalid source vm"
               memoryHandle.value = ""
               cpuHandle.value = ""
            }
        }
        else{
          console.log("Unknown Error with readystate or xhrstatus")
        }
     }
    xhr.send();

}, false); 


folderHandle.addEventListener('change', function(){
  
var xhr = new XMLHttpRequest();
    xhr.open('GET', `/clone_build/find_vms_of_folder.json?provider_id=${providerHandle.value}&folders=${folderHandle.value}`, true);
    loadingVmHandle.style.display = ""
    

    xhr.onreadystatechange = function(){
    if(xhr.readyState === 4 && xhr.status === 200){
      console.log("inside")
      var folderVmDetails = JSON.parse(xhr.responseText);
      console.log(folderVmDetails);
      vmHandle.innerHTML = '<option value="">--select VM--</option>'
      folderVmDetails["vms_folder"].forEach(function(vm){
                  var optionTag = document.createElement('option');
                  optionTag.setAttribute('value', vm.vm);
                  var text = document.createTextNode(vm.name);
                  optionTag.appendChild(text);
                  vmHandle.appendChild(optionTag);
          });
      loadingVmHandle.style.display = "none";
      
      }
      else
      {
        loadingVmHandle.style.display = "none";
      }
      }
  xhr.send();
}, false); 



providerHandle.addEventListener('change', function(){
	datacenterHandle.innerHTML = '<option value="">--select datacenter--</option>'
  
  sourceDcHandle.innerHTML = '<option value="">--select datacenter--</option>'
	clusterHandle.innerHTML = '<option value="">--select cluster--</option>'
	datastoreHandle.innerHTML = '<option value="">--select datastore--</option>'
	networkHandle.innerHTML = '<option value="">--select network--</option>'
    var xhr = new XMLHttpRequest();
    xhr.open('GET', `/clone_build/find_datacenters.json?provider_id=${providerHandle.value}`, true);
    loadingSdcHandle.style.display = ""
    loadingDatacenterHandle.style.display = ""
    xhr.onreadystatechange = function(){
    if(xhr.readyState === 4 && xhr.status === 200){
        var datacenterDetails = JSON.parse(xhr.responseText);
        datacenterHandle.innerHTML = '<option value=""> --select datacenter-- </option>'
        datacenterDetails.datacenters.forEach(function(datacenter){
                        var optionTag = document.createElement('option');
                        optionTag.setAttribute('value', datacenter.datacenter);
                        var text = document.createTextNode(datacenter.name);
                        optionTag.appendChild(text);
                        datacenterHandle.appendChild(optionTag);
                  });

        sourceDcHandle.innerHTML = '<option value="">--select datacenter--</option>'
        datacenterDetails.datacenters.forEach(function(datacenter){
                        var optionTag = document.createElement('option');
                        optionTag.setAttribute('value', datacenter.datacenter);
                        var text = document.createTextNode(datacenter.name);
                        optionTag.appendChild(text);
                        sourceDcHandle.appendChild(optionTag);

        });
        loadingSdcHandle.style.display = "none";
        loadingDatacenterHandle.style.display = "none";
        

    }
    else
    {
      loadingSdcHandle.style.display = "none";
    	loadingDatacenterHandle.style.display = "none"
      
    }
}
    xhr.send();


}, false); 


clusterHandle.addEventListener('change', function(){
	clusterNameHandle.value = clusterHandle.children[clusterHandle.selectedIndex].text;
}, false);


datacenterHandle.addEventListener('change', function(){
	datacenterNameHandle.value = datacenterHandle.children[datacenterHandle.selectedIndex].text;
}, false);

datastoreHandle.addEventListener('change', function(){
	datastoreNameHandle.value = datastoreHandle.children[datastoreHandle.selectedIndex].text;
}, false);

networkHandle.addEventListener('change', function(){
  networkNameHandle.value = networkHandle.children[networkHandle.selectedIndex].text;

}, false);

folderHandle.addEventListener('onload', function(){
  networkNameHandle.value = networkHandle.children[networkHandle.selectedIndex].text;
  

}, false);

folderHandle.addEventListener('change', function(){
  folderNameHandle.value = folderHandle.children[folderHandle.selectedIndex].text;

}, false);


vmHandle.addEventListener('change',function(){
  vmNameHandle.value = vmHandle.children[vmHandle.selectedIndex].text;
},false);

  sourceDcHandle.addEventListener('change', function(){
  var xhr = new XMLHttpRequest();
  xhr.open('GET', `/clone_build/find_folders.json?provider_id=${providerHandle.value}&source_dc=${sourceDcHandle.value}`, true);
  loadingFolderHandle.style.display = ""
  
  xhr.onreadystatechange = function(){
    if(xhr.readyState === 4 && xhr.status === 200){
      var folderDetails = JSON.parse(xhr.responseText);
      folderHandle.innerHTML = '<option value="">--select folder--</option>';
      //console.log( folderHandle.children[22].firstChild.textContent );
      folderDetails["folders"].forEach(function(folder){
                  var optionTag = document.createElement('option');
                  optionTag.setAttribute('value', folder.folder);
                  var text = document.createTextNode(folder.name);
                  optionTag.appendChild(text);
                  folderHandle.appendChild(optionTag);
          });
      loadingFolderHandle.style.display = "none";
      }
      else
    {
      loadingFolderHandle.style.display = "none";
      
    }
    }
  xhr.send();
}, false); 







datacenterHandle.addEventListener('change', function(){
	var xhr = new XMLHttpRequest();
	xhr.open('GET', `/clone_build/find_cdn.json?provider_id=${providerHandle.value}&datacenter=${datacenterHandle.value}`, true);
	loadingClusterHandle.style.display = ""
	loadingDatastoreHandle.style.display = ""
	loadingNetworkHandle.style.display = ""
	xhr.onreadystatechange = function(){
		if(xhr.readyState === 4 && xhr.status === 200){
			var receivedValue = JSON.parse(xhr.responseText);
			var cdnDetails = receivedValue["cdn"]    
			clusterHandle.innerHTML = '<option value="">--select cluster--</option>'
			cdnDetails["clusters"].forEach(function(cluster){
			            var optionTag = document.createElement('option');
			            optionTag.setAttribute('value', cluster.cluster);
			            var text = document.createTextNode(cluster.name);
			            optionTag.appendChild(text);
			            clusterHandle.appendChild(optionTag);
			    });
			loadingClusterHandle.style.display = "none"

		    datastoreHandle.innerHTML = '<option value="">--select datastore--</option>'
		    cdnDetails["datastores"].forEach(function(datastore){
	                    var optionTag = document.createElement('option');
	                    optionTag.setAttribute('value', datastore.datastore);
                      var text = document.createTextNode(datastore.name);
                      console.log(text);
	                    optionTag.appendChild(text);
                      var inGB = Math.round(datastore.free_space/1073741824);
                      var text1 = document.createTextNode("  "+inGB+" GB"+" free");
                      //var text1 = document.createTextNode(datastore.free_space);
                      console.log(text1);
                      console.log(inGB);
                      optionTag.appendChild(text1);
                      datastoreHandle.appendChild(optionTag);
			    });
                loadingDatastoreHandle.style.display = "none"

		    networkHandle.innerHTML = '<option value="">--select network--</option>'
		    cdnDetails["networks"].forEach(function(network){
	                    var optionTag = document.createElement('option');
	                    optionTag.setAttribute('value', network.network);
	                    var text = document.createTextNode(network.name);
	                    optionTag.appendChild(text);
	                    networkHandle.appendChild(optionTag);
			    });
            loadingNetworkHandle.style.display = "none"
	    }
	    else 
	    {
	    	loadingClusterHandle.style.display = "none"
	    	loadingDatastoreHandle.style.display = "none"
	    	loadingNetworkHandle.style.display = "none"
	    }

	}
	xhr.send();
}, false); 

// clusterHandle.addEventListener('change', function(){
//   var xhr = new XMLHttpRequest();
//   xhr.open('GET', `/clone_build/find_resource_pool.json?provider_id=${providerHandle.value}&cluster=${clusterHandle.value}`, true);
  
  
//   xhr.onreadystatechange = function(){
//     if(xhr.readyState === 4 && xhr.status === 200){
//       var newClusterDetails = JSON.parse(xhr.responseText);
//       console.log(newClusterDetails.resource_group);
//       //folderHandle.innerHTML = '<option value="">--select folder--</option>';
//       //console.log( folderHandle.children[22].firstChild.textContent );
      
//       newClusterHandle.value = newClusterDetails.resource_group;
      
//     }
//     }
//   xhr.send();
//   },false);