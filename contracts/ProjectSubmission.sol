// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.9.0;

/// @title Project Submission contract.
/// @author poulet.eth
contract ProjectSubmission {
    address public owner;
    // ...ownerBalance... // Step 4 (state variable)
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    struct University {
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
        string document;
        address author;
        address university;
        ProjectStatus status;
        uint256 balance;
    }
    Project[] public projects;

    constructor() public {
        owner = msg.sender;
    }

    function registerUniversity(address _address)
        public
        onlyOwner
        returns (bool)
    {
        universities[_address] = University(true, 0);
        return true;
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
        returns (bool)
    {
        require(msg.value <= 1 ether, "You need to pay 1ETH fee.");
        require(universities[_uni].available, "University is not available");

        projects.push(
            Project(_hash, msg.sender, _uni, ProjectStatus.Waiting, 0)
        );

        return true;
    }

    // function submitProject... { // Step 2 and 4
    //   ...
    // }

    // function disableProject... { // Step 3
    //   ...
    // }

    // function reviewProject... { // Step 3
    //   ...
    // }

    // function donate... { // Step 4
    //   ...
    // }

    // function withdraw... { // Step 5
    //   ...
    // }

    // function withdraw... {  // Step 5 (Overloading Function)
    //   ...
    // }
}
