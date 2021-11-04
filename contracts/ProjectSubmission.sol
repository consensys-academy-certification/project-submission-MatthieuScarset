// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.9.0;

/// @author Matthieu Scarset
/// @title Submit project to universities.
contract ProjectSubmission {
    // =============================================
    // Contract ownership.
    // =============================================
    address private owner;

    // ...ownerBalance... // Step 4 (state variable)

    // =============================================
    // Universities.
    // =============================================
    struct University {
        bool available;
        uint32 balance;
    }

    mapping(address => University) public universities;

    // =============================================
    // Projects.
    // =============================================
    enum ProjectStatus {
        Waiting,
        Rejected,
        Approved,
        Disabled
    }
    ProjectStatus projectStatus;

    struct Project {
        string document;
        address author;
        address university;
        uint16 status;
        uint256 balance;
    }

    mapping(address => Project[]) public projects;

    uint256 projectFeeAmount = 1;

    // =============================================
    // Modifiers.
    // =============================================

    // Restrict access to contract's owner.
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    // =============================================
    // Functions.
    // =============================================

    // Deploy this contract.
    /// @dev Sender is the owner.
    /// @dev Project fee amount is configurable by owner with setProjectFee().
    constructor() public {
        owner = msg.sender;
        projectFeeAmount = 1;
    }

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

    /// University registration
    /// @param _from the student identifier.
    /// @param _university the university identifier.
    /// @param _document the hash of the document.
    /// @dev students must pay a fee to submit project.
    function submitProject(
        address _from,
        address _university,
        string calldata _document
    ) external payable returns (bool) {
        // Check sender balance.
        require(
            msg.value >= this.getProjectFee(),
            "Not enough money to submit project."
        );

        // Check university exists and accepts project.
        University memory _uni = universities[_university];
        require(_uni.available, "University does not exists or is locked");

        Project memory _project = Project(
            _document,
            _from,
            _university,
            this.getDefaultProjectStatus(),
            0
        );

        projects[_university].push(_project);

        // Step 4
        return true;
    }

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

    /// Configurable project properties.
    function getDefaultProjectStatus() public pure returns (uint16) {
        return uint16(ProjectStatus.Waiting);
    }

    function setProjectFee(uint256 _amount) public onlyOwner {
        require(_amount >= 0, "Amount must be greated or equal to zero");
        projectFeeAmount = _amount;
    }

    function getProjectFee() public view returns (uint256) {
        return projectFeeAmount;
    }
}
