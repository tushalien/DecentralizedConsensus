pragma solidity ^0.4.18;
pragma experimental ABIEncoderV2;

contract Freelancer {

    uint id =0;
    struct User {
        address addr;
        bytes32 email;
        uint role; // 0 -> WebDev 1-> UI DEsigner 2-> SEO Specialist
    }
    
    struct Project {
        uint id;
        address client; 
        address freelancer;
        uint cost;
        bytes32 desc; // Basic Small Description of project
        bytes32 document;
        uint status;    //0-> Open 1-> Undertaken 2-> in Dispute 3->closed
      //  bytes32 time;
    }

    mapping (address => User[]) userinfo;  // one's public address to his details mapping
    mapping (uint => Project[]) projectinfo;  // id to project mapping

    Project[] projects;
    User[] users;

    function registerUser(bytes32 email, uint role) public payable {
        User memory user ;
        user.addr = msg.sender;
        user.email= email;
        user.role = role;
        userinfo[msg.sender].push(user);

        users.push(user);

    }

    function getUsers() public constant returns (address[],bytes32[], uint[]){
        address[] memory addr = new address[](users.length);
        bytes32[] memory email = new bytes32[](users.length);
        uint[] memory role = new uint[](users.length);
        for(uint i=0;i<users.length;i++){
            User storage u = users[i];
            addr[i] = u.addr;
            email[i] = u.email;
            role[i] = u.role;
        }

        return(addr, email, role);
    }
    

    function getUser() public constant  returns (bytes32, uint){
        //addr = msg.sender
        bytes32 email = userinfo[msg.sender][0].email;
        uint role = userinfo[msg.sender][0].role;
        return(email, role);
    }

    function getUserMail(address addr) public constant  returns (bytes32){
        bytes32 email = userinfo[addr][0].email;
        return(email);
    }

    function postProject(uint cost, bytes32 desc, bytes32 document) public payable {
        Project memory project ;
        project.id = 1;
        project.client = msg.sender;
        project.freelancer = msg.sender;
        project.cost = cost;
        project.desc = desc;
        project.document = document;
        project.status = 0;
        //project.time = "";
        projectinfo[id].push(project);
        projects.push(project);

    }

    function getProjects() public constant returns (uint[],bytes32[],uint[], bytes32[], bytes32[], uint[]){
        uint[] memory id = new uint[](projects.length);
        address[] memory addr = new address[](projects.length);
        bytes32[] memory cli_mail = new bytes32[](projects.length);
        uint[] memory cost = new uint[](projects.length);
        bytes32[] memory desc = new bytes32[](projects.length);
        bytes32[] memory document = new bytes32[](projects.length);
        uint[] memory status = new uint[](projects.length);

        for(uint i=0;i<users.length;i++){
            Project storage p = projects[i];
            id[i] = p.id;
            addr[i] = p.client;
            cli_mail[i]= getUserMail(addr[i]);
            cost[i]=p.cost;
            desc[i] = p.desc;
            document[i] = p.document;
            status[i] = p.status;
        }

        return(id, cli_mail, cost, desc, document, status);
    }

    function acceptProject(uint id ) public payable {
        projectinfo[id][0].freelancer = msg.sender;
        projectinfo[id][0].status = 1;
    }


}   