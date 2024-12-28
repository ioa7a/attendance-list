//
//  QRScannerView.swift
//  AttendanceScanner
//
//  Created by Ioana Bojinca on 16.11.2024.
//

import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseAuth

struct QRScannerView: View {
   private var email: String
   @State private var studentName: String = ""
   private let defaultValue = "No QR code detected"
   @State var scanResult = "No QR code detected"
   @State private var attendanceValidated: Bool = false
   @State private var alreadyScannedAttendance: Bool = false
   @State private var showProgressView: Bool = false
   
   init(email: String) {
      self.email = email
   }
   
   var body: some View {
      ZStack(alignment: .bottom) {
         QRScanner(result: $scanResult)
         VStack {
            if showProgressView {
               ProgressView()
            }
            
            ZStack(alignment: .center) {
               RoundedRectangle(cornerRadius: 20)
                  .frame(width: 200, height: 200, alignment: .center)
                  .foregroundStyle(.blue)
                  .background(.clear)
               VStack(spacing: 15) {
                  Image(systemName: "checkmark")
                     .resizable()
                     .frame(width: 50, height: 50)
                  Text("Attendance Validated!")
                     .font(.headline)
               }
               .background(.clear)
               .foregroundStyle(.white)
            }
            .opacity(attendanceValidated ? 1 : 0)
            .background(.clear)
            .padding(.vertical, 40)
            
            ZStack(alignment: .center) {
               RoundedRectangle(cornerRadius: 20)
                  .frame(width: 200, height: 200, alignment: .center)
                  .foregroundStyle(.red)
                  .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 5)
                  .background(.clear)
               VStack(spacing: 15) {
                  Image(systemName: "x.square")
                     .resizable()
                     .frame(width: 50, height: 50)
                  Text("Already scanned!")
                     .font(.headline)
               }
               .background(.clear)
               .foregroundStyle(.white)
            }
            .opacity(alreadyScannedAttendance ? 1 : 0)
            .background(.clear)
            .padding(.vertical, 40)
            
            Text(scanResult)
               .padding()
               .background(.black)
               .foregroundColor(.white)
               .padding(.bottom)
         }
      }
      .background(.clear)
      .onChange(of: scanResult) {
         withAnimation {
            showProgressView = true
            alreadyScannedAttendance = false
         }
         if scanResult != defaultValue {
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child("Attendance").child("\(scanResult)/students").updateChildValues([studentName: true])
            Task {
               var ref2: DatabaseReference!
               ref2 = Database.database().reference()
               // Check that student was added to attendance list
               let snapshot = try await ref2.child("Attendance/\(scanResult)/students/").getData()
               if let value = snapshot.value as? [String: Any] {
                  if value.keys.contains(where: { $0 == studentName }) {
                     DispatchQueue.main.async {
                        withAnimation {
                           showProgressView = false
                           attendanceValidated = true
                        }
                     }
                  }
               }
            }
         } else {
            withAnimation {
               showProgressView = false
               attendanceValidated = false
            }
         }
      }
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
