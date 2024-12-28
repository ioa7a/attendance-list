//
//  ScanAttendanceViewModel.swift
//  AttendanceScanner
//
//  Created by Ioana Bojinca on 23.12.2024.
//

import Foundation

class ScanAttendanceViewModel: ObservableObject {
   lazy var studentEmail: String = UserDefaultsManager.shared.getStudentEmail()
   @Published var studentName: String = Constant.notAvailable.rawValue
   @Published var isLoading: Bool = false
   @Published var backToLogin: Bool = false
   
   init() {
      self.getStudentData()
   }
   
   func getStudentData() {
      isLoading = true
      AttendanceDatabase.shared.getStudentData { [weak self] studentData in
         guard let self = self else {
            return
         }
         let loggedInStudent = studentData.first(where: {
            $0.email == self.studentEmail
         })?.name ?? Constant.notAvailable.rawValue
         self.studentName = loggedInStudent
         UserDefaultsManager.shared.setStudentName(studentName: loggedInStudent)
         self.isLoading = false
      }
   }
   
   func logout() {
      AuthService.shared.signOut { didSignOut, _ in
         UserDefaultsManager.shared.clearUserDefaults()
         self.backToLogin = didSignOut
      }
   }
}
