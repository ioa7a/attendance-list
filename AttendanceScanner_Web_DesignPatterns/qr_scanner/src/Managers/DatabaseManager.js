import { getDatabase, ref, set, onValue } from 'https://www.gstatic.com/firebasejs/11.0.2/firebase-database.js';// "firebase/database";    

export class DatabaseManager {
    db = getDatabase();
    courseData;
    studentData;
    attendanceList;

    constructor() {
        this.getCourseData();
        this.getStudentData();
    }

    // Get data
    getCourseData() {
        const courseDb = ref(this.db, "Courses");
        onValue(courseDb, (snapshot) => {
            const data = snapshot.val();
            this.courseData = data;
            this.updateCoursesUI()
        })
    }

    getStudentData() {
        const studentDb = ref(this.db,"Students");
        onValue(studentDb, (snapshot) => {
            const data = snapshot.val();
            this.studentData = data;
            this.updateStudentsUI()
        })
    }

    getAttendance(attendanceId) {
        const attendanceRef = ref(this.db, `Attendance/${attendanceId}`)
        onValue(attendanceRef, (snapshot) => {
            const attendanceData = snapshot.val();

            if (!attendanceData || !attendanceData.students) {
                console.log("No students found.");
                return;
            }

            this.updateAttendanceListUI(attendanceData)
        });
    }

    // Update UI
    updateCoursesUI() {
        var result = [];
        let arr = [];
        arr.push(this.courseData);
        $("courseTable").find("tr:gt(0)").remove();
        for (var i in arr[0]) {
            result.push([arr[0][i]]);
        }
        for (i = 0; i < result.length; i++) {
            var markup = "<tr class='trow'><td>" +
                result[i][0]['Id'] + "</td><td>" +
                result[i][0]['Name'] + "</td><td>" +
                result[i][0]['Students'].join(", ") + "</td><td>" +
                result[i][0]['Description'] + "</td><tr>";
            $("#courseTable tbody").append(markup);
        }
    }

    updateStudentsUI() {
        var studentResult = [];
        let studentArr = [];
        studentArr.push(this.studentData);
        $("studentTable").find("tr:gt(0)").remove();
        for (var i in studentArr[0]) {
            studentResult.push([studentArr[0][i]]);
        }
        for (i = 0; i < studentResult.length; i++) {
            var markup = "<tr class='trow'><td>" +
                studentResult[i][0]['Id'] + "</td><td>" +
                studentResult[i][0]['Name'] + "</td><td>" +
                studentResult[i][0]['Email'] + "</td><td>" +
                studentResult[i][0]['College'] + "</td><td>" +
                studentResult[i][0]['Grade'] + "</td><tr>";
            $("#studentTable tbody").append(markup);
        }
    }

    updateAttendanceListUI(attendanceData) {
        var students = attendanceData.students; 
        var studentList = `<b><div class="student">${attendanceData.courseName}</b></div>`
        studentList = studentList + Object.keys(students)
            .map(studentId => `<div class="student">${studentId}</div>`) // Generate HTML for each student
            .join("");

        // Display on the web page
        document.getElementById("studentsTable").innerHTML = studentList;
        console.log(studentList);
    }

    // Write to DB
    updateAttendance(attendanceIdValue, courseNameValue) {
        set(ref(this.db, "Attendance/" + attendanceIdValue), {
            students: [],
            courseName: courseNameValue
        }).then(() => {
            console.log("Attendance record added: ", attendanceIdValue, courseNameValue);
        }).catch((error) => {
            console.error("Error adding attendance record: ", error);
        });
    }
}

