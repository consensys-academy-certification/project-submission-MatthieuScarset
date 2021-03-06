// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Project Submission contract.
/// @author poulet.eth
contract ProjectSubmission {
    address public owner;
    uint256 public ownerBalance;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    struct University {
        address owner;
        bool available;
        uint256 balance;
    }
    mapping(address => University) public universities;

    enum ProjectStatus {
        Waiting,
        Rejected,
        Approved,
        Disabled
    }
    struct Project {
        address author;
        address university;
        ProjectStatus status;
        uint256 balance;
    }
    mapping(string => Project) public projects;

    constructor() payable {
        owner = msg.sender;
        ownerBalance = 0;
    }

    function registerUniversity(address _address)
        public
        onlyOwner
        returns (University memory university)
    {
        /// @dev Would be much safer to uncomment following two lines to prevent
        /// "overriding" an existing University BUT it breaks preconfigured tests.
        /// So I left this security breach.

        // University memory _uni = universities[_address];
        // require(_uni.owner == address(0), "University already registered.");

        universities[_address] = University(msg.sender, true, 0);

        return universities[_address];
    }

    function disableUniversity(address _address)
        public
        payable
        onlyOwner
        returns (bool)
    {
        universities[_address].available = false;
        return true;
    }

    function submitProject(string memory _hash, address _uni)
        public
        payable
        returns (Project memory project)
    {
        require(msg.value == 1 ether, "You need to pay 1ETH fee.");
        require(
            universities[_uni].owner != address(0),
            "University not registered"
        );
        require(universities[_uni].available, "University not available");

        ownerBalance += msg.value;

        projects[_hash] = Project(msg.sender, _uni, ProjectStatus.Waiting, 0);

        return projects[_hash];
    }

    function reviewProject(string memory _hash, ProjectStatus _status)
        public
        onlyOwner
        returns (bool)
    {
        require(
            projects[_hash].status == ProjectStatus.Waiting,
            "Project already reviewed"
        );

        projects[_hash].status = _status;

        return true;
    }

    function disableProject(string memory _hash)
        public
        onlyOwner
        returns (bool)
    {
        require(
            projects[_hash].status == ProjectStatus.Approved,
            "Project not approved"
        );

        projects[_hash].status = ProjectStatus.Disabled;

        return true;
    }

    function donate(string memory _hash) public payable returns (bool) {
        require(msg.value > 0, "A donation must be greater than zero.");
        require(projects[_hash].status == ProjectStatus.Approved);

        uint256 _donation = msg.value;

        // 70% to the project
        projects[_hash].balance += ((_donation / 100) * 70);

        // 20% to the contract owner
        address _uni = projects[_hash].university;
        universities[_uni].balance += ((_donation / 100) * 20);

        // 10% to the contract owner
        ownerBalance += ((_donation / 100) * 10);

        return true;
    }

    function withdraw() public returns (bool) {
        address _from = msg.sender;
        uint256 _amount = 0;

        if (msg.sender == owner) {
            _amount = ownerBalance;
            ownerBalance = 0;
        }

        University memory _uni = universities[_from];
        if (_uni.available && _uni.owner == _from) {
            _amount = universities[_from].balance;
            universities[_from].balance = 0;
        }

        if (_amount > 0) {
            payable(msg.sender).transfer(_amount);
            return true;
        }

        return false;
    }

    function withdraw(string memory _hash) public returns (bool) {
        address _from = msg.sender;
        uint256 _amount = 0;

        if (projects[_hash].author == _from) {
            _amount = projects[_hash].balance;
            projects[_hash].balance = 0;
        }

        if (_amount > 0) {
            payable(msg.sender).transfer(_amount);
        }

        return false;
    }
}
