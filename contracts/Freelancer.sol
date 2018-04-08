pragma solidity ^0.4.18;
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

    function Freelancer ()
    {
        owner = msg.sender;
    }

    modifier onlyOwner()
    {
        require(msg.sender == owner);
        _;
    }



    function generateHash(uint number, uint salt) public pure returns (uint) 
    {
        return uint(keccak256(number + salt));
    }

    function getRandom(uint a, uint b) public view returns (uint)  // b > a 
    {
        uint random_number = (uint(block.blockhash(block.number-1))%b + 1) - (uint(block.blockhash(block.number-1))%a + 1);
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
        token.transferFrom(src, dst, val);
        //token.transferFrom(msg.sender, this, 9900); // transfer the tokens
    }



    uint start_id =0;

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
        uint hash;
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
        uint status; //0-> Open 1-> Undertaken 2-> in Dispute 3->closed
        address[] juries;
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

    function getUserMail(address addr) public constant  returns (bytes32){
        bytes32 email = userinfo[addr].email;
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
        projectinfo[start_id] = project;
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

        for(uint i=0;i<projects.length;i++){
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
        projectinfo[id].freelancer = msg.sender;
        projectinfo[id].status = 1;
    }

    function closeProject(uint id ) public {
        projectinfo[id].status = 3;
    }

    function disputeProject(uint id ) public payable {
        projectinfo[id].status = 2;

    }



    
    function applyForJury(uint id , uint value) public payable {
        //Jury[] juries;
        // juries.push(msg.sender);
        // juryinvolved[msg.sender]= id;
        // juriesinaproject[id].push(Jury(id, msg.sender,value, 0,0,0));
        Jury memory j;
        j.addr = msg.sender;
        j.stake_tokens = value;
        j.vote=0; 
        j.hash=0;
        j.salt=0;
        //uint counter;
       // counter = projectinfo[id].juries.length;
        projectinfo[id].juries.push(msg.sender);
        juryinfo[msg.sender] = j;
    //     // uint counter; 
    //     // uint jury_id;
    //     // counter = projectinfo[id][0].jury + 1;
    //     // projectinfo[id][0].jury = counter;
    //     // jury_id = counter -  1;
    //     // jurylist[id][jury_id].addr = msg.sender;
    //     // sendTokens(msg.sender, this, value);
    //     // jurylist[id][jury_id].stake_tokens = value;
     }

    // function selectJury(uint id) onlyOwner public {

    // }

    function vote ( uint id, uint hash) public {
        require(juryinfo[msg.sender].id == id); 
        juryinfo[msg.sender].hash = hash;

    }

    function verifyJury(uint id, uint vote, uint salt) public returns(bool)
    {
        require(juryinfo[msg.sender].id == id);
        require(generateHash(vote, salt) == juryinfo[msg.sender].hash);
        juryinfo[msg.sender].vote = vote;
        return true;
    }

    // function redistributeTokens(uint id)
    // {
        
    // }

}   