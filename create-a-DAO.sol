// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleDAO {
    struct Proposal {
        string description; // Descripción de la propuesta
        address payable recipient; // Dirección para transferir fondos
        uint256 amount; // Monto a transferir
        uint256 voteCount; // Total de votos a favor
        bool executed; // Indica si la propuesta fue ejecutada
    }

    address public owner;
    uint256 public proposalCount;
    uint256 public votingPeriod; // Tiempo en segundos para votar
    mapping(uint256 => Proposal) public proposals; // ID de propuesta -> Propuesta
    mapping(address => bool) public members; // Dirección -> Es miembro
    mapping(uint256 => mapping(address => bool)) public votes; // ID de propuesta -> Votante -> Votó

    event ProposalCreated(uint256 id, string description, uint256 amount, address recipient);
    event Voted(uint256 id, address voter);
    event ProposalExecuted(uint256 id);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    modifier onlyMember() {
        require(members[msg.sender], "Not a DAO member");
        _;
    }

    constructor(uint256 _votingPeriod) {
        owner = msg.sender;
        votingPeriod = _votingPeriod;
    }

    function addMember(address _member) public onlyOwner {
        members[_member] = true;
    }

    function removeMember(address _member) public onlyOwner {
        members[_member] = false;
    }

    function createProposal(string memory _description, address payable _recipient, uint256 _amount) 
        public onlyMember returns (uint256) 
    {
        require(_amount <= address(this).balance, "Insufficient funds in DAO");

        proposals[proposalCount] = Proposal({
            description: _description,
            recipient: _recipient,
            amount: _amount,
            voteCount: 0,
            executed: false
        });

        emit ProposalCreated(proposalCount, _description, _amount, _recipient);
        return proposalCount++;
    }

    function vote(uint256 _proposalId) public onlyMember {
        Proposal storage proposal = proposals[_proposalId];
        require(!proposal.executed, "Proposal already executed");
        require(!votes[_proposalId][msg.sender], "Already voted");

        votes[_proposalId][msg.sender] = true;
        proposal.voteCount++;
        emit Voted(_proposalId, msg.sender);
    }

    function executeProposal(uint256 _proposalId) public onlyMember {
        Proposal storage proposal = proposals[_proposalId];
        require(!proposal.executed, "Proposal already executed");
        require(proposal.voteCount > 0, "Not enough votes"); // Simple mayoría: al menos 1 voto
        require(proposal.amount <= address(this).balance, "Insufficient DAO funds");

        proposal.executed = true;
        proposal.recipient.transfer(proposal.amount);
        emit ProposalExecuted(_proposalId);
    }

    receive() external payable {}

    fallback() external payable {}
}
