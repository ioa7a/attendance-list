//
//  QRScannerView.swift
//  AttendanceScanner
//
//  Created by Ioana Bojinca on 16.11.2024.
//

import SwiftUI
import Firebase
import FirebaseDatabase

struct QRScannerView: View {
   private var studentName: String
   private let defaultValue = "No QR code detected"
   @State var scanResult = "No QR code detected"
   @State private var attendanceValidated: Bool = false
   @State private var showProgressView: Bool = false
   
   init(studentName: String) {
      self.studentName = studentName
   }
   
   var body: some View {
      ZStack(alignment: .bottom) {
         QRScanner(result: $scanResult)
         VStack {
            if showProgressView {
               ProgressView()
            }
            
            withAnimation(.easeInOut(duration: 1)) {
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
            }
            
            Text(scanResult)
               .padding()
               .background(.black)
               .foregroundColor(.white)
               .padding(.bottom)
         }
      }
      .background(.clear)
      .onChange(of: scanResult) {
         showProgressView = true
         if scanResult != defaultValue {
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child("Attendance").child("\(scanResult)/students").updateChildValues(["\(studentName)": true])
            Task {
               // Check that student was added to attendance list
               let snapshot = try await ref.child("Attendance/\(scanResult)/students/").getData()
               if let value = snapshot.value as? [String: Any] {
                  if value.keys.contains(where: { $0 == studentName }) {
                     debugPrint("______ contains \(studentName)")
                     
                     DispatchQueue.main.async {
                        showProgressView = false
                        attendanceValidated = true
                     }
                  }
               }
            }
         } else {
            showProgressView = false
            attendanceValidated = false
         }
      }
   }
}

#Preview {
   QRScannerView(studentName: "Test")
}

