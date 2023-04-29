// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "verifier.sol";

contract Voting {

    //Define owner of the contract.
    address public owner;
    // **************************** PROPOSAL VARIABLES *****************************

    // Proposal Struct - Defines a proposal 
    struct Proposal {
        string title;
        string description;
        uint256 totalVotes;
        uint256[] candidateIds;
        bool exists;
    }

    mapping(uint256 => Proposal) public proposals;      // mapping of proposal structs. (array of proposals)
    uint256 public numProposals;                        // number of proposals.

    // **************************** CANDIDATE VARIABLES *****************************

    // Candidate Struct - Defines a Candidate 
    struct Candidate {
        string name;
        uint256 proposalId;
        uint256 votes;
        bool exists;
    }

    mapping(uint256 => Candidate) public candidates;        // Array of candidates 
    uint256 public numCandidates;                           // number of candidates

    // **************************** USER VARIABLES *****************************
    struct User {
        uint256 userId;
        address userAddress;
       
        
        
         
    //  string name;
    //  string email;
    //  string telephone;

    }

    mapping(uint256 => User) public users;              // Array of users 
    uint256 public numUsers;                           // number of users

    mapping(address => bool) public isRegistered;      // marks addresses that are registered.
    mapping(address => bool) public hasVoted;          // marks addresses that have voted.



    // The owner of the contract should not be allowed to access this function. i.e. voting function - owner is an admin account only.
    modifier onlyNotOwner() {
        require(msg.sender != owner, "The contract Owner cannot call this function.");
        _;
    }


    

    constructor (){
        owner = msg.sender;
    }
    
    // CREATE PROPOSAL - INPUT title AND DESCRIPTION - returns number of proposals (can be used for search) 
    function createProposal(string memory _title, string memory _description) public returns (uint256) {
        require(msg.sender == owner, "You do not have permission to create a proposal");
       
        numProposals++;
        Proposal storage p = proposals[numProposals];
        p.title = _title;
        p.description = _description;
        p.totalVotes = 0;
        p.exists = true;
        return numProposals;
    }
    
    
//****************************************** CANDIDATE FUNCTIONS ***************************************************************

    //CREATE CANDIDATE - INPUT PROPOSALID and NAME - returns number of candidates (can be used for search) 
    function addCandidate(uint256 _proposalId, string memory _name) public returns (uint256) {
        require(msg.sender == owner, "You do not have permission to create a proposal");
        require(proposals[_proposalId].exists, "Proposal does not exist");

        numCandidates++;
        Candidate storage c = candidates[numCandidates];
        c.name = _name;
        c.proposalId = _proposalId;
        c.votes = 0;
        c.exists = true;
        proposals[_proposalId].candidateIds.push(numCandidates);

        return numCandidates;
    }

        function getCandidate(uint256 _candidateId) public view returns (string memory, uint256, uint256) {
        require(candidates[_candidateId].exists, "Candidate does not exist");
        require(msg.sender == owner, "You do not have permission to search for candidates");
      
        Candidate memory c = candidates[_candidateId];
        return (c.name, c.proposalId, c.votes);
    }

//****************************************** END OF CANDIDATE FUNCTIONS ***************************************************************


    function vote(uint256 _candidateId) public onlyNotOwner {
        require(candidates[_candidateId].exists, "Candidate does not exist");
        require(!hasVoted[msg.sender], "User has already voted");
        Candidate storage c = candidates[_candidateId];
        Proposal storage p = proposals[c.proposalId];
        p.totalVotes++;
        c.votes++;
        hasVoted[msg.sender] = true;
    }

    function getProposal(uint256 _proposalId) public view returns (string memory, string memory, uint256) {
        require(proposals[_proposalId].exists, "Proposal does not exist");
        require(msg.sender == owner, "You do not have permission to search for candidates");
       
        Proposal memory p = proposals[_proposalId];
        return (p.title, p.description, p.totalVotes);
    }



    


//**************************************** USER FUNCTIONS ****************************************************************   

       // function addUser(string memory _name, string memory _email, string memory _telephone) public{


       // Instead of Personal Details - Lets use the assumption a unique pin is distributed. 
        function addUser(string memory _userId) public{
        require(msg.sender == owner, "You do not have permission to add new users");
        numUsers++;
        User storage u = users[numUsers];
        u.userId = _userId;
 //       u.name = _name;
 //       u.email = _email;
 //       u.telephone = _telephone;
    }
      
        
    // GET USER - input user address and return their details
    function getUser(address _userAddress) public view returns (bool) {
        bool exists;
       for (uint256 i = 0; i < numUsers; i++) {
           if(_userAddress == users[i].userAddress){
               exists = true;
               return exists;
       //         _name = users[i].name;
       //         _email = users[i].email;
       //        _userId = users[i].userId; 

       //        return (_name, _email, _userId);
           }
            exists = false;
            return exists;
       }
    }

        function getUserByNum(address _index) public view returns (string) {
            
            return users[_index];
       }
    


 function registerUser(string memory _userId) public view returns (bool) {
        bool registered;
        for (uint256 i = 0; i < numUsers; i++) {

            if(compare(_userId, users[i].userId)){ 
                users[i].userAddress = msg.sender;     // if input credentials match those on record. Add address to record. 
                isRegistered[msg.sender] = true; 
                return registered = true;           
            }
        }
    }

//****************************************  END OF USER FUNCTIONS **************************************************************** 


    //  COMPARE STRINGS - USES keccak256() is a hashing function supported by Solidity 
    //  AND abi.encodePacked() encodes a value using the Application Binary Interface (ABI) 
    function compare(string memory str1, string memory str2) internal view returns (bool) {
        if (bytes(str1).length != bytes(str2).length) {
            return false;
        }
        return keccak256(abi.encodePacked(str1)) == keccak256(abi.encodePacked(str2));
    }


    // zkSnarks Test
    function verifyProof(
    uint256[2] memory a,
    uint256[2] memory b1, uint256[2] memory b2,
    uint256[2] memory c,
    uint256[2] memory input
    ) public view returns (bool) {
    // function body


    }

    
}

