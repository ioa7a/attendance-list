//
//  UserDefaultsManager.swift
//  AttendanceScanner
//
//  Created by Ioana Bojinca on 23.12.2024.
//

import Foundation

public final class UserDefaultsManager {
   public static let shared = UserDefaultsManager()
   private lazy var defaults = UserDefaults.standard
   
   private init() {}
   
   public func setStudentEmail(email: String) {
      defaults.set(email, forKey: UserDefaultsKeys.studentEmail.rawValue)
   }
   
   public func setStudentName(studentName: String) {
      defaults.set(studentName, forKey: UserDefaultsKeys.studentName.rawValue)
   }
   
   public func getStudentName() -> String {
      return defaults.string(forKey: UserDefaultsKeys.studentName.rawValue) ?? Constant.notAvailable.rawValue
   }
   
   public func getStudentEmail() -> String {
      return defaults.string(forKey: UserDefaultsKeys.studentEmail.rawValue) ?? Constant.notAvailable.rawValue
   }
   
   public func setAttendanceScanned(attendanceId: String) {
      defaults.set(true, forKey: attendanceId)
   }
   
   public func getAttendanceScanStatus(attendanceId: String) -> Bool {
      return defaults.bool(forKey: attendanceId)
   }
   
   public func clearUserDefaults() {
      defaults.removeObject(forKey: UserDefaultsKeys.studentName.rawValue)
      defaults.removeObject(forKey: UserDefaultsKeys.studentEmail.rawValue)
   }
}
