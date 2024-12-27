//
//  Constants.swift
//  AttendanceScanner
//
//  Created by Ioana Bojinca on 23.12.2024.
//

import SwiftUI

public class Constants {
   public static let scanAttendanceView = "ScanAttendanceView"
   public static let welcomeBack = "Welcome Back!"
   public static let NA = "N/A"
   public static let noQrCode = "No QR code detected"
   public static let emailTitle = "Email"
   public static let passwordTitle = "Password"
   public static let emailError = "Please enter a valid email address."
   public static let passwordError = "Please enter your password."
   public static let validationFailed = "Validation Failed!"
   public static let validationSuccess = "Attendance Validated!"
   public static let alreadyScanned = "Already Scanned!"
   public static let enterCredentials = "Please enter your credentials to sign in."
   public static let errorText = "Something went wrong."
   public static let tryAgainLater = "Please try again later."
   public static let signIn = "Sign In"
   public static let signOut = "Sign Out"
   public static let scanCode = "Scan Attendance Code"
   public static let loading = "Loading..."
}

extension Image {
   public static let logoIcon = Image("logo-icon")
   public static let errorIcon = Image(systemName: "exclamationmark.triangle")
   public static let attendanceSuccess = Image(systemName: "checkmark")
   public static let attendanceFail = Image(systemName: "x.square")
}
