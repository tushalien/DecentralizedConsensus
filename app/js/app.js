import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract'

import freelancer_artifacts from '../../build/contracts/Freelancer.json'

var Freelancer = contract(freelancer_artifacts);
//console.log(Freelancer);





window.registerUser = function(form) {
  let client = web3.eth.accounts[0];
  let email = $('#email').val();
  let role = $('#role').val();

  console.log(client,email,role);
  Freelancer.deployed().then(function(contractInstance){
    console.log(contractInstance);
    contractInstance.registerUser(email,role,{gas: 1400000, from: web3.eth.accounts[0]})
    .then(function(){
      console.log("User registered");
    })
    .catch(function(){
      console.log("User Registration failed");
    })
  })
}

window.getUsers = function(){

  let fields = [ 'addr', 'email', 'role'];
  let users = {};
  console.log(Freelancer);
  Freelancer.deployed().then(function(contractInstance){
  	console.log(contractInstance);
    contractInstance.getUsers.call()
    .then(function(res)
    {
      	for(let i=0;i<res[i].length;i++)
      	{
        	let obj = {};
        	for(let j=0;j<fields.length;j++)
        	{
          		obj[fields[j]] = res[j][i].toString();
            	if(j==1)
            	obj[fields[j]] = web3.toAscii(obj[fields[j]]);
			}
        	users[i]=obj;
      	}
      	console.log(users);
	})
    })
}


window.postProject = function(form) {
  let desc = $('#desc').val();
  let doc = $('#doc').val();
  let cost = $('#cost').val();

  Freelancer.deployed().then(function(contractInstance){
    contractInstance.postProject(cost,desc,doc,{gas: 1400000, from: web3.eth.accounts[0]})
    .then(function(){
      console.log("Project Posted");
    })
    .catch(function(){
      console.log("Project not posted!!");
    })
  })
}

window.getProjects = function(){
//id, cli_mail, cost, desc, document, status
  let fields = [ 'id', 'cli_email', 'cost', 'desc', 'document', 'status'];
  let projects = {};
  Freelancer.deployed().then(function(contractInstance){
    contractInstance.getProjects.call()
    .then(function(res)
    { 
        console.log("Hello");
        console.log(res);
        for(let i=0;i<res[i].length;i++)
        {
          let obj = {};
          for(let j=0;j<fields.length;j++)
          {
              obj[fields[j]] = res[j][i].toString();
              if(j==1 || j==3 || j==4 )
              obj[fields[j]] = web3.toAscii(obj[fields[j]]);
      }
          projects[i]=obj;
        }
        console.log(projects);
  })
    })
}





$( document ).ready(function()
 {
  if (typeof web3 !== 'undefined') {
    console.warn("Using web3 detected from external source like Metamask")
    // Use Mist/MetaMask's provider
    window.web3 = new Web3(web3.currentProvider);

   // console.log(window.web3);
    console.log(web3.eth.accounts[0]);
  } else {
    console.warn("No web3 detected. Falling back to http://localhost:8545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask");
    window.web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
  }
    Freelancer.setProvider(web3.currentProvider);

});
