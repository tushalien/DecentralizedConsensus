pragma solidity ^0.4.18;pragma solidity ^0.4.18;
pragma experimental ABIEncoderV2;


contract ERC20Events {
    event Approval(address indexed src, address indexed guy, uint wad);
    event Transfer(address indexed src, address indexed dst, uint wad);
}

contract ERC20 is ERC20Events {
    function totalSupply() public view returns (uint);
    function balanceOf(address guy) public view returns (uint);
    function allowance(address src, address guy) public view returns (uint);

    function approve(address guy, uint wad) public returns (bool);
    function transfer(address dst, uint wad) public returns (bool);
    function transferFrom(
        address src, address dst, uint wad
    ) public returns (bool);
}


contract Freelancer  {
    
    address owner;
    uint project_id;

    function Freelancer() public payable{
        owner = msg.sender;
    }

    modifier onlyOwner()
    {
        require(msg.sender == owner);
        _;
    }


 
   function generateHash(uint number, uint salt) public pure returns (bytes32) 
    {
        return (keccak256(number + salt));
    }

    function getRandom(uint b) public view returns (uint)  // b > a 
    {
        uint random_number = (uint(block.blockhash(block.number-1))%b + 1);
        return random_number;
    }



    mapping (address => uint256) public balances;

    event LogDeposit(address sender, uint amount);
    event LogWithdrawal(address receiver, uint amount);
    event LogTransfer(address sender, address to, uint amount);

    function deposit() payable public returns(bool success) {
        balances[msg.sender] += msg.value;
        LogDeposit(msg.sender, msg.value);
        return true;
    }

    function withdraw(uint value) payable public returns(bool success) {
        require(balances[msg.sender] < value) ;
        balances[msg.sender] -= value;
        msg.sender.transfer(value);
        LogWithdrawal(msg.sender, value);
        return true;
    }

    function transfer(address to, uint value) public returns(bool success) {
        require(balances[msg.sender] < value);
        balances[msg.sender] -= value;
        to.transfer(value);
        LogTransfer(msg.sender, to, value);
        return true;
    }

    function sendTokens(address src, address dst, uint val) public 
    { 
        address _tokenAddress = address(0x011d3e0c95A9658301D95F51Dfa9B00778F2Ad7f);
        ERC20 token = ERC20(_tokenAddress);
        require(token.balanceOf(msg.sender) >= 100); 
        val = val*1000000000;
        token.transferFrom(src, dst, val);
        //token.transferFrom(msg.sender, this, 9900); // transfer the tokens
    }



    uint start_id =0;
        uint yes=0;
        uint totalStakes=0;
        uint no=0;
        uint yes_tokens=0;
        uint no_tokens=0;
        uint etherstodist;
        uint tokenstodist;
    struct User {
        address addr;
        bytes32 email;
        uint role; // 0 -> WebDev 1-> UI DEsigner 2-> SEO Specialist
    }
    
    struct Jury {
        uint id;
        address addr;
        uint stake_tokens;
        uint vote; // 0- > NOt voted, 1-> TRue, 2-> False
        bytes32 hash;
        uint salt;
    }
    //Jury[] juries;
    
    struct Project {
        uint id;
        address client; 
        address freelancer;
        uint cost;
        bytes32 desc; // Basic Small Description of project
        bytes32 document;
        uint project_status; //0-> Open 1-> Undertaken 2-> in Dispute 3->closed
        address[] juries;
        address[] applied;
      //  bytes32 time;
    }

    
    Project[] projects;
    User[] users;
    //address[] juries;


    mapping (address => User) userinfo;  // one's public address to his details mapping
    mapping (uint => Project) projectinfo;  // id to project mapping
    mapping (uint => Jury[] ) juriesinaproject;
    mapping (address => uint) juryinvolved;
    mapping (address => Jury) juryinfo;

    function registerUser(bytes32 email, uint role) public payable {
        require (userinfo[msg.sender].addr != msg.sender);
        User memory user ;
        user.addr = msg.sender;
        user.email= email;
        user.role = role;
        userinfo[msg.sender] = user;
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
        bytes32 email = userinfo[msg.sender].email;
        uint role = userinfo[msg.sender].role;
        return(email, role);
    }

    function getUserMail(address addr) public  returns (bytes32){
        bytes32 email = userinfo[addr].email;
        return(email);
    }

    function postProject(uint cost, bytes32 desc, bytes32 document) public payable returns (bool) {
        Project memory project ;
        project.id = project_id++;
        project.client = msg.sender;
        project.freelancer = msg.sender;
        project.cost = msg.value;
        project.desc = desc;
        project.document = document;
        project.project_status = 0;
        projectinfo[project.id] = project;
        balances[msg.sender] += msg.value;
        LogDeposit(msg.sender, msg.value);
        projects.push(project);
        return true;
    
    }

    function getProjects() public constant returns (uint[],bytes32[],uint[], bytes32[], bytes32[], uint[]){
        uint[] memory id = new uint[](projects.length);
        address[] memory addr = new address[](projects.length);
        bytes32[] memory cli_mail = new bytes32[](projects.length);
        uint[] memory cost = new uint[](projects.length);
        bytes32[] memory desc = new bytes32[](projects.length);
        bytes32[] memory document = new bytes32[](projects.length);
        uint[] memory status = new uint[](projects.length);

        for(uint i=0;i<projects.length;i++){
            Project storage p = projectinfo[i];
            id[i] = p.id;
            addr[i] = p.client;
            cli_mail[i]= getUserMail(addr[i]);
            cost[i]=p.cost;
            desc[i] = p.desc;
            document[i] = p.document;
            status[i] = p.project_status;
        }
        return(id, cli_mail, cost, desc, document, status);
    }

    function getProjectsByAddress() public returns (uint[],bytes32[], bytes32[], uint[],bytes32[], uint[]){
        uint[] memory id = new uint[](projects.length);
        bytes32[] memory cli_mail = new bytes32[](projects.length);
        bytes32[] memory free_mail = new bytes32[](projects.length);
        uint[] memory cost = new uint[](projects.length);
        bytes32[] memory desc = new bytes32[](projects.length);
        uint[] memory status = new uint[](projects.length);
        for(uint i=0;i<projects.length;i++){
            Project storage p = projectinfo[i];
            if (p.client == msg.sender || p.freelancer == msg.sender)
            {
            id[i] = p.id;
            cli_mail[i]= getUserMail(p.client);
            free_mail[i]= getUserMail(p.freelancer);
            cost[i]=p.cost;
            desc[i] = p.desc;
            status[i] = p.project_status;
            }
        }
        
        return(id, cli_mail,free_mail, cost, desc,status);
    }



    function acceptProject(uint id ) public payable {
        Project storage project = projectinfo[id];
        project.freelancer = msg.sender;
        project.project_status = 1;
        balances[msg.sender] += msg.value;
        LogDeposit(msg.sender, msg.value);
    }

    function closeProject(uint id ) public {
        require (projectinfo[id].client == msg.sender || projectinfo[id].freelancer== msg.sender);
        Project storage project = projectinfo[id];
        if ( project.client== msg.sender && project.project_status == 1 )
            project.project_status = 3;
        if ( project.freelancer== msg.sender && project.project_status == 1 )
            project.project_status = 4;
        if ( project.client== msg.sender && project.project_status == 4 )
            project.project_status = 5;
        if ( project.freelancer== msg.sender && project.project_status == 3 )
            project.project_status = 5;

    }
    // 3 client closed
    // 4 freelancer closed
    // 5 both closed
    function disputeProject(uint id ) public {
        require (projectinfo[id].client == msg.sender || projectinfo[id].freelancer == msg.sender);
        Project storage project = projectinfo[id];
        require(project.project_status != 0 && project.project_status != 5);
        project.project_status = 2;


    }



    
    function applyForJury(uint id , uint value) public payable {
        Jury memory j;
        j.addr = msg.sender;
        j.stake_tokens = value;
        sendTokens(msg.sender, this , value);
        projectinfo[id].applied.push(msg.sender);
        juryinfo[msg.sender] = j;

     }

    function selectJury(uint id) onlyOwner public returns (bool)
    {
        Project storage project = projectinfo[id];
        uint[] memory range = new uint[](project.applied.length);
        uint[] memory randompool = new uint[](project.applied.length);
        address[] memory jury = new address[](project.applied.length);
        for(uint i=0;i<project.applied.length;i++){
            jury[i] = project.applied[i];
        }

        range[0] =0 ;
        for(uint x=0;x<project.applied.length;x++){
            range[x] += juryinfo[jury[x]].stake_tokens;
        }
        for(uint a=0;a<project.applied.length;a++){
            randompool[a] = getRandom(range[(project.applied.length)-1]);
        }
        uint y=0;
        for(uint b=0;b<project.applied.length && y < 5;b++){
            if ( randompool[y] < range[b])
            {
                project.juries.push(juryinfo[jury[b]].addr);
            }
            y++;
        }

        //needs some thoughtful thinking :P
        return true;
    }

    function voteJury ( uint id, bytes32 hash) public {
        require(juryinfo[msg.sender].id == id);
        Jury storage jury = juryinfo[msg.sender];
        jury.hash = hash;

    }

    function verifyJury(uint id, uint vote, bytes32 hash) public returns(bool)
    {
        require(juryinfo[msg.sender].id == id);
        require(hash == juryinfo[msg.sender].hash);
        Jury storage jury = juryinfo[msg.sender];
        jury.vote = vote;
        return true;
    }

    function redistributeFunds(uint id) onlyOwner public returns (bool)
    {
        address[] memory jury = new address[](projectinfo[id].juries.length);
        for(uint i=0;i<projectinfo[id].juries.length;i++){
            jury[i] = projectinfo[id].juries[i];
        }

        for(uint c=0;c<jury.length;c++){
            totalStakes+=juryinfo[jury[c]].stake_tokens;
            if ( juryinfo[jury[c]].vote == 1)
            {
                yes++;
                yes_tokens+=juryinfo[jury[c]].stake_tokens;
            }
            else
            {
                no++;
                no_tokens+=juryinfo[jury[c]].stake_tokens;
            }
        }

        if (yes>no)
        {
            projectinfo[id].freelancer.transfer(balances[projectinfo[id].freelancer]);
            balances[projectinfo[id].freelancer] = 0;
            etherstodist = (balances[projectinfo[id].client])/jury.length;
            tokenstodist = (totalStakes - yes_tokens)/yes;
            balances[projectinfo[id].client] = 0;
            for(uint m=0;m<jury.length;m++)
            {
                uint tokens = 0;
                if ( juryinfo[jury[m]].vote == 1)
                {
                    tokens = juryinfo[jury[m]].stake_tokens + tokenstodist;
                    sendTokens(this, juryinfo[jury[m]].addr, tokens);
                }
                projectinfo[id].juries[m].transfer(etherstodist);
                
            }
        }
        else
        {
            projectinfo[id].client.transfer(balances[projectinfo[id].client]);
            balances[projectinfo[id].client] = 0;
            etherstodist = (balances[projectinfo[id].freelancer])/jury.length;
            tokenstodist = (totalStakes - no_tokens)/no;
            balances[projectinfo[id].freelancer] = 0;
            for(uint k=0;i<jury.length;k++)
            {
                uint tokens_1 = 0;
                if ( juryinfo[jury[i]].vote == 2)
                {
                    tokens_1 = juryinfo[jury[i]].stake_tokens + tokenstodist;
                    sendTokens(this, juryinfo[jury[i]].addr, tokens_1);
                }
                projectinfo[id].juries[i].transfer(etherstodist);
                
            }

        }
    }
}   