var providerHandle = document.getElementById('provider');
var datacenterHandle = document.getElementById('datacenter');
var clusterHandle = document.getElementById('cluster');
var clusterNameHandle = document.getElementById('cluster_name');
var datacenterNameHandle = document.getElementById('datacenter_name');
var datastoreHandle = document.getElementById('datastore');
var datastoreNameHandle = document.getElementById('datastore_name');
var networkHandle = document.getElementById('network');
var loadingDatacenterHandle = document.getElementById('loading-datacenter');
var loadingClusterHandle = document.getElementById('loading-cluster');
var loadingNetworkHandle = document.getElementById('loading-network');
var loadingDatastoreHandle = document.getElementById('loading-datastore');
var vmHandle = document.getElementById('source_vm');
var TvmHandle = document.getElementById('target_vm');
var vmErrorHandle = document.getElementById('vm_error');
var TvmErrorHandle = document.getElementById('tvm_error');
var memoryHandle = document.getElementById('memoryMB');
var cpuHandle = document.getElementById('numCPUs')

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

TvmHandle.addEventListener('change', function(){
  var xhr = new XMLHttpRequest();
    xhr.open('GET', `/clone_build/find_vms.json?provider_id=${providerHandle.value}&source_vm=${TvmHandle.value}`, true);

    xhr.onreadystatechange = function(){
    if(xhr.readyState === 4 && xhr.status === 200){
        var vmDetails = JSON.parse(xhr.responseText);
          if (JSON.stringify(vmDetails) != '{"vms":[]}') {
               TvmErrorHandle.innerHTML = "vm name is taken"
            }
          else
            {
               TvmErrorHandle.innerHTML = ""
            }
        }
        else{
          console.log("Unknown Error with readystate or xhrstatus")
        }
}
    xhr.send();

}, false);


providerHandle.addEventListener('change', function(){
	datacenterHandle.innerHTML = '<option value="">--select datacenter--</option>'
	clusterHandle.innerHTML = '<option value="">--select cluster--</option>'
	datastoreHandle.innerHTML = '<option value="">--select datastore--</option>'
	networkHandle.innerHTML = '<option value="">--select network--</option>'
    var xhr = new XMLHttpRequest();
    xhr.open('GET', `/clone_build/find_datacenters.json?provider_id=${providerHandle.value}`, true);
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

        loadingDatacenterHandle.style.display = "none"
    }
    else
    {
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
	                    optionTag.appendChild(text);
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
