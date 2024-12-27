//
//  ScanAttendanceView.swift
//  AttendanceScanner
//
//  Created by Ioana Bojinca on 18.11.2024.
//

import SwiftUI
import FirebaseDatabase

struct ScanAttendanceView: View {
   @State private var studentName: String = ""
   private var email: String
   
   init(email: String) {
      self.email = email
   }
   
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Text("Welcome back \(studentName)!")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                NavigationLink("Scan Attendance Code") {
                   QRScannerView(email: email)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 80)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
           var ref: DatabaseReference!
           ref = Database.database().reference()
           Task {
              let snapshot = try await ref.child("Students").getData()
              do {
                 guard let value = snapshot.value as? [[String: Any]] else {
                    return
                 }
                 
                 let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                 let decoded = try JSONDecoder().decode([Student].self, from: jsonData)
                 let students: [Student] = decoded
                 let loggedInStudent = students.first(where: { $0.email == email })
                 self.studentName = loggedInStudent?.name ?? "N/A"
              } catch {
                 print("ERROR HERE: \(error)")
              }
           }
        }
    }
}

#Preview {
   ScanAttendanceView(email: "test@test.com")
}
