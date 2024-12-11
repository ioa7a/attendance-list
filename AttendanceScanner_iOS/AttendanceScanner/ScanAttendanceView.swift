//
//  ScanAttendanceView.swift
//  AttendanceScanner
//
//  Created by Ioana Bojinca on 18.11.2024.
//

import SwiftUI

struct ScanAttendanceView: View {
   private var studentName: String
   
   init(studentName: String) {
      self.studentName = studentName
   }
   
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Text("Welcome back \(studentName)!")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                NavigationLink("Scan Attendance Code") {
                   QRScannerView(studentName: studentName)
                }
               
               
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 80)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
   ScanAttendanceView(studentName: "test")
}
