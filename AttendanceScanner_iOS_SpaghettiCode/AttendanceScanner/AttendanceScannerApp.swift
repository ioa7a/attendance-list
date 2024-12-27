//
//  AttendanceScannerApp.swift
//  AttendanceScanner
//
//  Created by Ioana Bojinca on 15.11.2024.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
   
   func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
      return true
   }
   
}

@main
struct AttendanceScannerApp: App {
   @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
   
   var body: some Scene {
      WindowGroup {
         AuthenticationView()
      }
   }
}
