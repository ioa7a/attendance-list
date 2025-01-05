import { initializeApp } from 'https://www.gstatic.com/firebasejs/11.0.2/firebase-app.js';// "firebase/app";
import { getAuth, signInWithEmailAndPassword, signOut } from 'https://www.gstatic.com/firebasejs/11.0.2/firebase-auth.js'; // 'firebase/auth'
import { getDatabase, ref, child, get, set, onValue } from 'https://www.gstatic.com/firebasejs/11.0.2/firebase-database.js';// "firebase/database";    
import { getPerformance } from "https://www.gstatic.com/firebasejs/11.0.2/firebase-performance.js";

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
const perf = getPerformance(app);

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
        result[i][0]['Id'] + "</td><td>" +
        result[i][0]['Name'] + "</td><td>" +
        result[i][0]['Students'].join(", ") + "</td><td>" +
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
  let attendanceId = "id"
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
}

setInterval(getAttendance, 10000);
var students
function getAttendance() {
  const db = getDatabase(app);
  const attendanceRef = ref(db, `Attendance/${finalAttendanceId}`);
  onValue(attendanceRef, (snapshot) => {
    const attendanceData = snapshot.val();
 
    if (!attendanceData || !attendanceData.students) {
      console.log("No students found.");
      return;
    }
 
    students = attendanceData.students; // Get the students object
    var studentList = `<b><div class="student">${attendanceData.courseName}</b></div>`
    studentList =  studentList + Object.keys(students)
      .map(studentId => `<div class="student">${studentId}</div>`) // Generate HTML for each student
      .join("");
 
    // Display on the web page
    document.getElementById("studentsTable").innerHTML = studentList;
    console.log("______ GET STUDENT LIST:");
    console.log(studentList);
  });
}

const signInButton = document.getElementById("signIn");
if (signInButton) {
  signInButton.addEventListener("click", signIn);
}

// Authentication methods
function signIn() {
  const auth = getAuth();
  var email = document.getElementById("email");
  var password = document.getElementById("password");

  if (!email.value || !password.value) {
    console.log("No students found.");
    alert("Please enter your credentials");
    return;
  }

  console.log(email.value);
  console.log(password.value);
  signInWithEmailAndPassword(auth, email.value, password.value)
  .then((userCredential) => {
    alert("Active user: " + email.value);
    location.href = 'MainView.html';
  })
  .catch((error) => {
    const errorCode = error.code;
    const errorMessage = error.message;
    alert("ERROR: " + errorCode + " " + errorMessage);
  });
}

const signOutButton = document.getElementById("signOut");
if (signOutButton) {
  signOutButton.addEventListener("click", logOut);
}
function logOut() {
  const auth = getAuth()
  auth.signOut().then(() => {
    console.log('Signed Out');
    location.href = 'SignInView.html'
  })
}