//
//  Student.swift
//  AttendanceScanner
//
//  Created by Ioana Bojinca on 23.12.2024.
//

import Foundation

public struct Student: Codable, Hashable {
   var college: String?
   var email: String?
   var grade: Int?
   var id: String?
   var name: String?
   
   enum CodingKeys: String, CodingKey {
      case college = "College"
      case email = "Email"
      case grade = "Grade"
      case id = "Id"
      case name = "Name"
   }
}
