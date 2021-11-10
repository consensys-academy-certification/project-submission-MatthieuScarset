pragma solidity >=0.5.17 <=0.8.10;

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

    // enum ProjectStatus { ... } // Step 2
    // struct Project { // Step 2
    //     ...author...
    //     ...university...
    //     ...status...
    //     ...balance...
    // }
    // ...projects... // Step 2 (state variable)

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
        onlyOwner
        returns (bool)
    {
        universities[_address].available = false;
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
