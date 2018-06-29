var providerHandle = document.getElementById('provider');
var datacenterNameHandle = document.getElementById('datacenter_name');
var loadingSdcHandle = document.getElementById('loading-sdc');
var loadingFolderHandle = document.getElementById('loading-folder');
var loadingVmHandle = document.getElementById('loading-vm');
var vmHandle = document.getElementById('source_vm');
var sourceDcHandle = document.getElementById('source_dc');
var folderHandle = document.getElementById('folders');
var vmNameHandle = document.getElementById('source_vm_name');

vmHandle.addEventListener('change', function(){
var xhr = new XMLHttpRequest();
    xhr.open('GET', `/power_management/find_vms.json?provider_id=${providerHandle.value}&source_vm=${vmHandle.value}`, true);
    
    xhr.onreadystatechange = function(){
      if(xhr.readyState === 4 && xhr.status === 200 ){
          var vmDetails = JSON.parse(xhr.responseText);
          }
     }
    xhr.send();

}, false); 


folderHandle.addEventListener('change', function(){
  
var xhr = new XMLHttpRequest();
    xhr.open('GET', `/power_management/find_vms_of_folder.json?provider_id=${providerHandle.value}&folders=${folderHandle.value}`, true);
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
	sourceDcHandle.innerHTML = '<option value="">--select datacenter--</option>'
    var xhr = new XMLHttpRequest();
    xhr.open('GET', `/power_management/find_datacenters.json?provider_id=${providerHandle.value}`, true);
    loadingSdcHandle.style.display = ""
    xhr.onreadystatechange = function(){
    if(xhr.readyState === 4 && xhr.status === 200){
        var datacenterDetails = JSON.parse(xhr.responseText);
        
        sourceDcHandle.innerHTML = '<option value="">--select datacenter--</option>'
        datacenterDetails.datacenters.forEach(function(datacenter){
                        var optionTag = document.createElement('option');
                        optionTag.setAttribute('value', datacenter.datacenter);
                        var text = document.createTextNode(datacenter.name);
                        optionTag.appendChild(text);
                        sourceDcHandle.appendChild(optionTag);

        });
        loadingSdcHandle.style.display = "none";
       

    }
    else
    {
      loadingSdcHandle.style.display = "none";
      
    }
}
    xhr.send();

}, false); 


folderHandle.addEventListener('onload', function(){
  networkNameHandle.value = networkHandle.children[networkHandle.selectedIndex].text;

}, false);

vmHandle.addEventListener('change',function(){
  vmNameHandle.value = vmHandle.children[vmHandle.selectedIndex].text;
},false);

  sourceDcHandle.addEventListener('change', function(){
  var xhr = new XMLHttpRequest();
  xhr.open('GET', `/power_management/find_folders.json?provider_id=${providerHandle.value}&source_dc=${sourceDcHandle.value}`, true);
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
