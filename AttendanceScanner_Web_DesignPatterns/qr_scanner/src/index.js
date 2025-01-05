import { initializeApp } from 'https://www.gstatic.com/firebasejs/11.0.2/firebase-app.js';
import { getPerformance } from "https://www.gstatic.com/firebasejs/11.0.2/firebase-performance.js";
import { AuthenticationManager } from "./Managers/AuthManager.js";
import { DatabaseManager } from "./Managers/DatabaseManager.js";
import { QrCodeFactory } from './Managers/QrCodeFactory.js';

const firebaseConfig = {
  apiKey: "AIzaSyDe0WsQnpZOtXiM-ElP08JJFh6FdBfMSa8",
  authDomain: "attendance-list-a1261.firebaseapp.com",
  databaseURL: "https://attendance-list-a1261-default-rtdb.firebaseio.com",
  projectId: "attendance-list-a1261",
  storageBucket: "attendance-list-a1261.firebasestorage.app",
  messagingSenderId: "945236703930",
  appId: "1:945236703930:web:8fb32927c7d3909bfca083"
};

// Singleton
const app = initializeApp(firebaseConfig);
getPerformance(app);
const databaseManager = new DatabaseManager();
const authManager = new AuthenticationManager();
Object.freeze(authManager);

// Constants
const signInButton = document.getElementById("signIn");
if (signInButton) {
  signInButton.addEventListener("click", signIn);
}

const signOutButton = document.getElementById("signOut");
if (signOutButton) {
  signOutButton.addEventListener("click", logOut);
}

const qrCodeButton = document.getElementById("getQRCode");
if (qrCodeButton) {
  qrCodeButton.addEventListener("click", generateQRCode);
}

const qrCodeView = document.getElementById("qrCodeView");

// Variables
let finalAttendanceId;
let courseName = document.getElementById("courseName");
let qrCode;

// Authentication methods
function signIn() {
  var email = document.getElementById("email");
  var password = document.getElementById("password");

  if (!email.value || !password.value) {
    alert("Please enter your credentials");
    return;
  }

  authManager.signIn(email.value, password.value);
}

function logOut() {
  authManager.signOut();
}

// Generate QR Code
function generateQRCode() {
  if (qrCodeView) {
    if (!courseName.value || courseName.value == "") {
      alert("Please enter a course name.");
      return;
    }

    // Generate QR Code
    let qrCodeFactory = new QrCodeFactory(courseName.value, qrCodeView);
    qrCodeFactory.getNewQrCodeId();
    qrCodeFactory.setQrCode(qrCode);
    qrCodeFactory.generateQrCode();

    // create entry in database for attendance code
    databaseManager.updateAttendance(finalAttendanceId, courseName.value);
    databaseManager.getAttendance(finalAttendanceId);
  }
}