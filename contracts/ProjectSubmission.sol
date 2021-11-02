// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.9.0;

/// @author Matthieu Scarset
/// @title Submit project to universities.
contract ProjectSubmission {
    address private owner;

    // ...ownerBalance... // Step 4 (state variable)

    struct University {
        bool available;
        uint32 balance;
    }

    mapping(address => University) public universities;

    // Restrict access to contract's owner.
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    // Set deployer as the owner.
    constructor() {
        owner = msg.sender;
    }

    // enum ProjectStatus { ... } // Step 2
    // struct Project { // Step 2
    //     ...author...
    //     ...university...
    //     ...status...
    //     ...balance...
    // }
    // ...projects... // Step 2 (state variable)

    /// University registration
    /// @param _from the account owner for this university
    /// @dev contract's owner creates a university, saved in state variable.
    function registerUniversity(address _from) public onlyOwner returns (bool) {
        // Get existing university.
        University memory _uni = universities[_from];

        // Prevent registrations if university was disabled by owner or if
        // university exists (e.g. non-zero balance).
        require(
            _uni.available && _uni.balance == 0,
            "University is locked or has a non-zero balance."
        );

        // Create or reset university.
        universities[_from] = University(true, 0);
        return true;
    }

    /// Locked a University.
    /// @param _from the account owner of the university.
    /// @dev irreversible. should not be called before "registerUniversity()".
    function disableUniversity(address _from) public onlyOwner returns (bool) {
        universities[_from].available = false;
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
