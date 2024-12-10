import { initializeApp } from 'https://www.gstatic.com/firebasejs/11.0.2/firebase-app.js';// "firebase/app";
import { getAuth } from 'https://www.gstatic.com/firebasejs/11.0.2/firebase-auth.js'; // 'firebase/auth'
import { getDatabase, ref, child, get, set, onValue } from 'https://www.gstatic.com/firebasejs/11.0.2/firebase-database.js';// "firebase/database";    

const firebaseConfig = {
  apiKey: "AIzaSyDe0WsQnpZOtXiM-ElP08JJFh6FdBfMSa8",
  authDomain: "attendance-list-a1261.firebaseapp.com",
  databaseURL: "https://attendance-list-a1261-default-rtdb.firebaseio.com",
  projectId: "attendance-list-a1261",
  storageBucket: "attendance-list-a1261.firebasestorage.app",
  messagingSenderId: "945236703930",
  appId: "1:945236703930:web:8fb32927c7d3909bfca083"
};

const app = initializeApp(firebaseConfig);

const dbRef = ref(getDatabase());
get(child(dbRef, "Courses")).then((snapshot) => {
  if (snapshot.exists()) {
    const courseData = snapshot.val()
    var result = [];
    let arr = [];
    arr.push(courseData);
    $("courseTable").find("tr:gt(0)").remove();
    for(var i in arr[0]){
        result.push([arr[0][i]]);
    }
    for (i = 0; i <result.length; i++) { 
        var markup = "<tr class='trow'><td>" + 
        result[i][0]['Name'] + "</td><td>" +
        result[i][0]['Description'] + "</td><tr>";
        $("#courseTable tbody").append(markup);
    }
  } else {
    console.log("No data available");
  }
}).catch((error) => {
  console.error(error);
});

get(child(dbRef, "Students")).then((snapshot) => {
  if (snapshot.exists()) {
    const studentData = snapshot.val()
    var studentResult = [];
    let studentArr = [];
    studentArr.push(studentData);
    $("studentTable").find("tr:gt(0)").remove();
    for(var i in studentArr[0]){
      studentResult.push([studentArr[0][i]]);
    }
    for (i = 0; i <studentResult.length; i++) { 
        var markup = "<tr class='trow'><td>" + 
        studentResult[i][0]['Id'] + "</td><td>" +
        studentResult[i][0]['Name'] + "</td><td>" +
        studentResult[i][0]['Email'] + "</td><td>" +
        studentResult[i][0]['College'] + "</td><td>" +
        studentResult[i][0]['Grade'] + "</td><tr>";
        $("#studentTable tbody").append(markup);
    }
  } else {
    console.log("No data available");
  }
}).catch((error) => {
  console.error(error);
});

const auth = getAuth();

const coursesButton = document.getElementById("coursesButton");
if (coursesButton) {
  coursesButton.addEventListener("click", getCourses);
}

const qrCodeButton = document.getElementById("getQRCode");
if (qrCodeButton) {
  qrCodeButton.addEventListener("click", generateQRCode);
}

function getCourses() {
  location.href = 'CoursesView.html';
}

let courseName = document.getElementById("courseName");
let qrCode;
const qrCodeView = document.getElementById("qrCodeView");

let finalAttendanceId; 
function generateQRCode() {
  let attendanceId = "id" + Math.random().toString(16).slice(2)
  let date = Date.now()
  finalAttendanceId = attendanceId + "_" + courseName.value.trim() + "_" + date
  console.log(attendanceId)

  if (!courseName.value || courseName.value == "") {
    alert("Please enter a course name.");
    return;
  }

  if (qrCodeView) {
    // generate QR code
    if (qrCode == null) {
      qrCode = new QRCode(qrCodeView, finalAttendanceId);
     }
     else {
      qrCode.makeCode(finalAttendanceId);
    }

    // create entry in database for attendance code
    setAttendance(finalAttendanceId, courseName.value);
  }
}

function setAttendance(finalAttendanceIdValue, courseNameValue) {
  const db = getDatabase(app);
    set(ref(db, 'Attendance/' + finalAttendanceIdValue), {
      students: [],
      courseName: courseNameValue // Store the actual course name value
    }).then(() => {
      console.log("Attendance record added:", finalAttendanceIdValue, courseNameValue);
    }).catch((error) => {
      console.error("Error adding attendance record:", error);
    });

    // getAttendance();
    setInterval(getAttendance, 10000);
}

function getAttendance() {
  // const db = getDatabase(app);
  // const attendanceRef = ref(db, `Attendance/${finalAttendanceId}`);
  // onValue(attendanceRef, (snapshot) => {
  //   const students = snapshot.val() || {};
  //   const studentList = Object.keys(students)
  //     .map(studentId => `<div class="student">${studentId}</div>`)
  //     .join("");
  //     document.getElementById("students").innerHTML = studentList;
  //   console.log("______ GET STUDENT LIST:");
  //   console.log(studentList);

  const db = getDatabase(app);
  const attendanceRef = ref(db, `Attendance/${finalAttendanceId}`);
  onValue(attendanceRef, (snapshot) => {
    const attendanceData = snapshot.val();
 
    if (!attendanceData || !attendanceData.students) {
      console.log("No students found.");
      return;
    }
 
    const students = attendanceData.students; // Get the students object
    const studentList = Object.keys(students)
      .map(studentId => `<div class="student">${studentId}</div>`) // Generate HTML for each student
      .join("");
 
    // Display on the web page
    document.getElementById("students").innerHTML = studentList;
    console.log("______ GET STUDENT LIST:");
    console.log(studentList);
  });
}