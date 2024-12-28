//
//  QRScannerViewModel.swift
//  AttendanceScanner
//
//  Created by Ioana Bojinca on 23.12.2024.
//

import Foundation
import SwiftUI

final class QRScannerViewModel: ObservableObject {
   private let defaultValue = Constant.noQrCode.rawValue
   @Published var showProgressView: Bool = false
   @Published var attendanceValidated: Bool = false
   @Published var showAttendanceError: Bool = false
   @Published var errorMessage: String?
   
   var scanResultViewLabelText: String {
      return showAttendanceError ? errorMessage ??
      Constant.validationFailed.rawValue :
      Constant.validationSuccess.rawValue
   }
   
   var scanResultViewLabelImageName: Image {
      return showAttendanceError ? Image.attendanceFail : Image.attendanceSuccess
   }
   
   lazy var studentName: String = UserDefaultsManager.shared.getStudentName()
   
   func scanAttendance(scanResult: String) {
      self.showProgressView = true
      attendanceValidated = false
      showAttendanceError = false
      errorMessage = nil
      DispatchQueue.global(qos: .background).async { [weak self] in
         guard let self,
               scanResult != self.defaultValue else {
            return
         }
         if UserDefaultsManager.shared.getAttendanceScanStatus(attendanceId: scanResult) {
            self.updateUI(showError: true,
                          errorMessage: Constant.alreadyScanned.rawValue)
         } else {
            AttendanceDatabase.shared.addStudentAttendance(attendanceReference: scanResult,
                                                           studentName: self.studentName)
            UserDefaultsManager.shared.setAttendanceScanned(attendanceId: scanResult)
            self.validateAttendance(with: scanResult)
         }
      }
   }
   
   func validateAttendance(with scanResult: String) {
      AttendanceDatabase.shared.getStudentAttendance(attendanceReference: scanResult) { attendanceResult in
         if !attendanceResult.isEmpty,
            attendanceResult.keys.contains(where: {
               $0 == self.studentName
            }) {
            self.updateUI()
         } else {
            self.updateUI(showError: true,
                          errorMessage: Constant.validationFailed.rawValue)
         }
      }
   }
   
   func updateUI(showError: Bool = false, errorMessage: String? = nil) {
      DispatchQueue.main.async { [weak self] in
         guard let self = self else {
            return
         }
         self.showProgressView = false
         self.showAttendanceError = showError
         self.errorMessage = errorMessage
         withAnimation {
            self.attendanceValidated = true
         }
      }
   }
}
