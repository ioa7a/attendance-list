//
//  AttendanceDatabase.swift
//  AttendanceScanner
//
//  Created by Ioana Bojinca on 23.12.2024.
//

import Foundation
import FirebaseDatabase

public final class AttendanceDatabase {
   public static var shared: AttendanceDatabase = AttendanceDatabase()
   private(set) var isFetchingData: Bool = false
   private lazy var dbRef: DatabaseReference = Database.database().reference()
   private let studentDbName = "Students"
   private let attendanceDbName = "Attendance"
   
   private init() {}
   
   public func getStudentData(_ completion: @escaping ([Student]) -> Void) {
      dbRef.child(studentDbName).observeSingleEvent(of: .value, with: { snapshot in
         guard let value = snapshot.value as? [[String: Any]],
               let jsonData = try? JSONSerialization.data(withJSONObject: value, options: []),
               let decodedStudentData = try? JSONDecoder().decode([Student].self, from: jsonData) else { return }
         completion(decodedStudentData)
      }, withCancel: { error in
         print("ERROR WHILE GETTING STUDENT DATA: \(error.localizedDescription)")
         completion([])
      })
   }
   
   public func addStudentAttendance(attendanceReference: String, studentName: String) {
      let dbPath = getAttendanceDbPath(attendanceId: attendanceReference)
      let dbValue = [studentName: true]
      dbRef.child(dbPath)
         .updateChildValues(dbValue)
   }
   
   public func getStudentAttendance(attendanceReference: String, _ completion: @escaping ([String: Any]) -> Void) {
      let dbPath = self.getAttendanceDbPath(attendanceId: attendanceReference)
      dbRef.child(dbPath).observe(.value, with: { snapshot  in
         if let value = snapshot.value as? [String: Any] {
            completion(value)
         }
      }, withCancel: { error in
         print("ERROR WHILE GETTING STUDENT ATTENDANCE: \(error.localizedDescription)")
         completion([:])
      })
   }
   
   private func getAttendanceDbPath(attendanceId: String) -> String {
      "\(attendanceDbName)/\(attendanceId)/\(studentDbName.lowercased())/"
   }
}
