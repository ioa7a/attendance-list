//
//  Constants.swift
//  AttendanceScanner
//
//  Created by Ioana Bojinca on 23.12.2024.
//

import SwiftUI

public enum Constant: String {
   case scanAttendanceView = "ScanAttendanceView"
   case welcomeBack = "Welcome Back!"
   case notAvailable = "N/A"
   case noQrCode = "No QR code detected"
   case emailTitle = "Email"
   case passwordTitle = "Password"
   case emailError = "Please enter a valid email address."
   case passwordError = "Please enter your password."
   case validationFailed = "Validation Failed!"
   case validationSuccess = "Attendance Validated!"
   case alreadyScanned = "Already Scanned!"
   case enterCredentials = "Please enter your credentials to sign in."
   case errorText = "Something went wrong."
   case tryAgainLater = "Please try again later."
   case signIn = "Sign In"
   case signOut = "Sign Out"
   case scanCode = "Scan Attendance Code"
   case loading = "Loading..."
}

extension Image {
   public static let logoIcon = Image("logo-icon")
   public static let errorIcon = Image(systemName: "exclamationmark.triangle")
   public static let attendanceSuccess = Image(systemName: "checkmark")
   public static let attendanceFail = Image(systemName: "x.square")
}
