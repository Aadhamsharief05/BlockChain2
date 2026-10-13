# Student Attendance Smart Contract

A Solidity smart contract that lets an authorized faculty member register students and record
and retrieve their attendance on the Ethereum Virtual Machine (EVM).

## Features
- Owner (deployer) is the first authorized faculty member and can authorize or revoke others
- Faculty-only student registration and attendance recording
- Date-based records (YYYYMMDD) with duplicate-entry rejection
- Public read functions: student name, attendance for a date, attendance summary
- Events for every state change

## Functions
| Function | Access |
|---|---|
| `authorizeFaculty(address)` / `revokeFaculty(address)` | Owner |
| `registerStudent(uint256 id, string name)` | Faculty |
| `markAttendance(uint256 id, uint256 date, bool isPresent)` | Faculty |
| `getStudent(id)`, `getAttendance(id, date)`, `getAttendanceSummary(id)` | Public (view) |

## Run in Remix IDE
1. Open https://remix.ethereum.org and create `contracts/StudentAttendance.sol`; paste the code.
2. Solidity Compiler tab: choose version 0.8.20 or higher and compile.
3. Deploy & Run: choose the Remix VM (JavaScript VM) environment, then Deploy.
4. Try `registerStudent(101, "Student A")`, `markAttendance(101, 20261013, true)`, then `getAttendance` and `getAttendanceSummary`.

## Documentation
See `test-cases.md`, `deployment-details.md` and the `screenshots/` folder.

## Licence
MIT
