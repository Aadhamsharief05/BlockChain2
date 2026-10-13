// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title StudentAttendance
/// @notice Lets authorized faculty record and retrieve student attendance.
contract StudentAttendance {
    // ---------- State ----------
    address public owner;                        // deployer, first faculty
    mapping(address => bool) public isFaculty;   // authorized faculty

    struct Student {
        string name;
        bool registered;
        uint256 totalClasses;    // days on which attendance was recorded
        uint256 presentClasses;  // days marked present
    }

    mapping(uint256 => Student) private students;                    // id => student
    mapping(uint256 => mapping(uint256 => bool)) private recorded;   // id => date => recorded?
    mapping(uint256 => mapping(uint256 => bool)) private present;    // id => date => present?

    // ---------- Events ----------
    event FacultyAuthorized(address indexed faculty);
    event FacultyRevoked(address indexed faculty);
    event StudentRegistered(uint256 indexed studentId, string name);
    event AttendanceRecorded(uint256 indexed studentId, uint256 indexed date,
                             bool isPresent, address indexed recordedBy);

    // ---------- Modifiers ----------
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner allowed");
        _;
    }

    modifier onlyFaculty() {
        require(isFaculty[msg.sender], "Not authorized faculty");
        _;
    }

    modifier studentExists(uint256 studentId) {
        require(students[studentId].registered, "Student not registered");
        _;
    }

    constructor() {
        owner = msg.sender;
        isFaculty[msg.sender] = true;
        emit FacultyAuthorized(msg.sender);
    }

    // ---------- Faculty management (owner only) ----------
    function authorizeFaculty(address faculty) external onlyOwner {
        require(faculty != address(0), "Invalid address");
        require(!isFaculty[faculty], "Already authorized");
        isFaculty[faculty] = true;
        emit FacultyAuthorized(faculty);
    }

    function revokeFaculty(address faculty) external onlyOwner {
        require(faculty != owner, "Cannot revoke owner");
        require(isFaculty[faculty], "Not a faculty member");
        isFaculty[faculty] = false;
        emit FacultyRevoked(faculty);
    }

    // ---------- Student registration (faculty only) ----------
    function registerStudent(uint256 studentId, string calldata name)
        external onlyFaculty
    {
        require(studentId != 0, "Invalid student ID");
        require(bytes(name).length > 0, "Name required");
        require(!students[studentId].registered, "Student already registered");
        students[studentId] = Student(name, true, 0, 0);
        emit StudentRegistered(studentId, name);
    }

    // ---------- Attendance recording (faculty only) ----------
    /// @param date Date in YYYYMMDD format, e.g. 20261013
    function markAttendance(uint256 studentId, uint256 date, bool isPresent)
        external onlyFaculty studentExists(studentId)
    {
        require(date >= 20000101 && date <= 99991231, "Invalid date (YYYYMMDD)");
        require(!recorded[studentId][date], "Attendance already recorded");

        recorded[studentId][date] = true;
        present[studentId][date] = isPresent;

        Student storage s = students[studentId];
        s.totalClasses += 1;
        if (isPresent) {
            s.presentClasses += 1;
        }
        emit AttendanceRecorded(studentId, date, isPresent, msg.sender);
    }

    // ---------- Retrieval (public, read-only) ----------
    function getStudent(uint256 studentId)
        external view studentExists(studentId) returns (string memory name)
    {
        return students[studentId].name;
    }

    function getAttendance(uint256 studentId, uint256 date)
        external view studentExists(studentId)
        returns (bool isRecorded, bool isPresent)
    {
        return (recorded[studentId][date], present[studentId][date]);
    }

    function getAttendanceSummary(uint256 studentId)
        external view studentExists(studentId)
        returns (uint256 total, uint256 presentDays,
                 uint256 absentDays, uint256 percentage)
    {
        Student storage s = students[studentId];
        total = s.totalClasses;
        presentDays = s.presentClasses;
        absentDays = total - presentDays;
        percentage = total == 0 ? 0 : (presentDays * 100) / total;
    }
}
