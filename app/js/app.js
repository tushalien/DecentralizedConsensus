import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract'
const bs58 = require('bs58');


import freelancer_artifacts from '../../build/contracts/Freelancer.json'
var Freelancer = contract(freelancer_artifacts);

// LIbrary - Utility Functions

function getBytes32FromIpfsHash(ipfsListing) {
  return "0x"+bs58.decode(ipfsListing).slice(2).toString('hex');
}

function getIpfsHashFromBytes32(bytes32Hex) {
  const hashHex = "1220" + bytes32Hex.slice(2);
  const hashBytes = Buffer.from(hashHex, 'hex');
  const hashStr = bs58.encode(hashBytes)
  return hashStr;
}


// Event triggered functions


// window.upload = function()
// {
//       const reader = new FileReader();
//       reader.onloadend = function() {
//         const ipfs = window.IpfsApi('localhost', 5001) 
//         const buf = buffer.Buffer(reader.result) // Convert data into buffer
//         ipfs.files.add(buf, (err, result) => { // Upload buffer to IPFS
//           if(err) {
//             console.error(err)
//             return
//           }
//           let url = `https://ipfs.io/ipfs/${result[0].hash}`
//           console.log(`Url --> ${url}`)
//           console.log(result[0].hash);
//           ipfshash = result[0].hash;
//           ipfshash = getBytes32FromIpfsHash(ipfshash);
//           console.log(ipfshash);
//         })
//       }
//       const doc = document.getElementById("doc");
//       reader.readAsArrayBuffer(doc.files[0]); // Read Provided File

// }


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
 
        let ipfshash;
       const reader = new FileReader();
      reader.onloadend = function() {
        const ipfs = window.IpfsApi('localhost', 5001) 
        const buf = buffer.Buffer(reader.result) // Convert data into buffer
        ipfs.files.add(buf, (err, result) => { // Upload buffer to IPFS
          if(err) {
            console.error(err)
            return
          }
          else
          {

          ipfshash = getBytes32FromIpfsHash(result[0].hash);
          }
          let url = `https://ipfs.io/ipfs/${result[0].hash}`
          console.log(`Url --> ${url}`)
          console.log(result[0].hash);

            let desc = $('#desc').val();
  //let doc ;      //ipfs hash 
  //ipfs code goes here
  //doc = getBytes32FromIpfsHash(ipfshash)
  let cost = $('#cost').val()*1000;
console.log(cost,desc,ipfshash);
  Freelancer.deployed().then(function(contractInstance){
    contractInstance.postProject(cost,desc,ipfshash,{gas: 1400000, from: web3.eth.accounts[0],value:web3.toWei(cost, "finney")})
    .then(function(){
      console.log("Project Posted");
    })
    .catch(function(){
      console.log("Project not posted!!");
    })
  })


          console.log(ipfshash);
        })
      }
      const doc = document.getElementById("doc");
      reader.readAsArrayBuffer(doc.files[0]); // Read Provided File





}


window.getProjects = function(){
  let fields = [ 'id', 'cli_email', 'cost', 'desc', 'document', 'status'];
  let projects = {};
  console.log(getIpfsHashFromBytes32("0x1df8db7c03c3cdac8c2694e1a183024fff5a3e12a544b0a852294539c66b5089"));
  Freelancer.deployed().then(function(contractInstance){
    contractInstance.getProjects.call()
    .then(function(res)
    {   
        //console.log("Hello");
        console.log(res);
        for(let i=0;i<res[i].length;i++)
        {
          let obj = {};
          for(let j=0;j<fields.length;j++)
          {
              obj[fields[j]] = res[j][i].toString();
              if(j==1 || j==3)
                obj[fields[j]] = web3.toAscii(obj[fields[j]]);
              if (j==4)
                obj[fields[j]] = getIpfsHashFromBytes32(obj[fields[j]]);  // retrieves ipfs hash
      }
          projects[i]=obj;
        }
        
        console.log(projects);
  })
    })
}


window.acceptProject = function() {
  let id = parseInt($('#project_id').val());
  let ether = parseInt($('#project_cost').val())*0.2;
  Freelancer.deployed().then(function(contractInstance){
    contractInstance.acceptProject(id,{gas: 1400000, from: web3.eth.accounts[0],value:web3.toWei(ether, "wei")})
    .then(function(){
      console.log("Project Accepted");
    })
    .catch(function(){
      console.log("Project not accepted!!");
    })
  })
}


window.closeProject = function(form) {
  let id = $('#project_id').val();
  Freelancer.deployed().then(function(contractInstance){
    contractInstance.closeProject(id,{gas: 1400000, from: web3.eth.accounts[0]})
    .then(function(){
      console.log("Project Closed");
    })
    .catch(function(){
      console.log("Project not closed!!");
    })
  })
}


window.disputeProject = function(form) {
  let id = $('#project_id').val();
  Freelancer.deployed().then(function(contractInstance){
    contractInstance.disputeProject(id,{gas: 1400000, from: web3.eth.accounts[0]})
    .then(function(){
      console.log("Project Under Dispute");
    })
    .catch(function(){
      console.log("Project noy under Dispute");
    })
  })
}


window.applyForJury = function(form) {
  let id = $('#project_id').val();
  let tokens = parseInt($('#tokens').val());
  Freelancer.deployed().then(function(contractInstance){
    contractInstance.applyForJury(id,tokens,{gas: 1400000, from: web3.eth.accounts[0]})
    .then(function(){
      console.log("Applied for Jury");
    })
    .catch(function(){
      console.log("Application for Jury wasn't success");
    })
  })
}

window.selectJury = function() {
  let id = $('#project_id').val();
  Freelancer.deployed().then(function(contractInstance){
    contractInstance.selectJury(id,{gas: 1400000, from: web3.eth.accounts[0]})
    .then(function(){
      console.log("Jury Selection Done");
    })
    .catch(function(){
      console.log("Jury Selection - Error !!");
    })
  })
}

window.voteJury = function(form) {
  let id = $('#project_id').val();
  let vote = $('#vote').val();
  let salt = $('#salt').val();
  let hash = web3.sha3(vote.toString()+salt)

  Freelancer.deployed().then(function(contractInstance){
    contractInstance.acceptProject(id,hash,{gas: 1400000, from: web3.eth.accounts[0]})
    .then(function(){
      console.log("Voting Done");
    })
    .catch(function(){
      console.log("Vote not done");
    })
  })
}


window.verifyJury = function(form) {
  let id = $('#project_id').val();
  let vote = $('#vote').val();
  let salt = $('#salt').val();
  let hash = web3.sha3(vote.toString()+salt)


  Freelancer.deployed().then(function(contractInstance){
    contractInstance.verifyJury(id,vote,hash,{gas: 1400000, from: web3.eth.accounts[0]})
    .then(function(){
      console.log("Jury Verified");
    })
    .catch(function(){
      console.log("Jury not verified");
    })
  })
}


window.redistributeFunds = function() {
  let id = $('#project_id').val();
  Freelancer.deployed().then(function(contractInstance){
    contractInstance.redistributeFunds(id,{gas: 1400000, from: web3.eth.accounts[0]})
    .then(function(){
      console.log("Funds distributed !!");
    })
    .catch(function(){
      console.log("Redistribution - Error !!");
    })
  })
}


/////     Experimemntal Features :P //////////////////////////

window.deposit = function(form) {
  let ether = $('#sendether').val();

  Freelancer.deployed().then(function(contractInstance){
    contractInstance.deposit({gas: 1400000, from: web3.eth.accounts[0],value:web3.toWei(ether, "ether")})
    .then(function(){
      console.log("Ether Deposited");
    })
    .catch(function(){
      console.log("Ether not Deposited");
    })
  })
}


window.withdraw = function(form) {
  let ether = $('#recieveether').val();
  ether =100000000000000000; //convert into wei
  Freelancer.deployed().then(function(contractInstance){
    contractInstance.withdraw(ether,{gas: 1400000, from: web3.eth.accounts[0]})
    .then(function(){
      console.log("Ether Withdrawl");
    })
    .catch(function(){
      console.log("Ether not Withdrawl");
    })
  })
}


////////////////////////////////////////////////////////////////

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
