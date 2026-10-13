# Test Cases and Results

Fill in the last two columns after running each test in Remix. Do not enter results you have not observed.

| ID | Test Scenario | Input / Action | Expected Result | Actual Result | Status |
|---|---|---|---|---|---|
| TC1 | Contract deployment | Deploy from Account 1 | Deployed; `owner()` is Account 1; `isFaculty(Account 1)` is true | [Enter actual result] | [Pass/Fail after testing] |
| TC2 | Student registration | `registerStudent(101, "Student A")` by Account 1 | Succeeds; `StudentRegistered` event | [Enter actual result] | [Pass/Fail after testing] |
| TC3 | Duplicate student registration | `registerStudent(101, "Student A")` again | Reverts: "Student already registered" | [Enter actual result] | [Pass/Fail after testing] |
| TC4 | Attendance recording | `markAttendance(101, 20261013, true)` by Account 1 | Succeeds; `AttendanceRecorded` event | [Enter actual result] | [Pass/Fail after testing] |
| TC5 | Attendance retrieval | `getAttendance(101, 20261013)` | `isRecorded = true`, `isPresent = true` | [Enter actual result] | [Pass/Fail after testing] |
| TC6 | Duplicate attendance | `markAttendance(101, 20261013, true)` again | Reverts: "Attendance already recorded" | [Enter actual result] | [Pass/Fail after testing] |
| TC7 | Unauthorized access | `markAttendance(101, 20261014, true)` by Account 2 | Reverts: "Not authorized faculty" | [Enter actual result] | [Pass/Fail after testing] |
| TC8 | Unregistered student | `markAttendance(999, 20261013, true)` by Account 1 | Reverts: "Student not registered" | [Enter actual result] | [Pass/Fail after testing] |
| TC9 | Attendance summary | `getAttendanceSummary(101)` after TC4 only | total 1, present 1, absent 0, percentage 100 | [Enter actual result] | [Pass/Fail after testing] |
