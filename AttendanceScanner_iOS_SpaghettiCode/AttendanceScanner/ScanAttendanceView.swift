//
//  ScanAttendanceView.swift
//  AttendanceScanner
//
//  Created by Ioana Bojinca on 18.11.2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct ScanAttendanceView: View {
   @Binding var path: NavigationPath
   @State private var studentName: String = ""
   @State private var backToLogin: Bool = false
   private var email: String
   
   init(email: String, navigationPath: Binding<NavigationPath>) {
      self.email = email
      _path = navigationPath
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
               
               Button {
                  do {
                     try Auth.auth().signOut()
                     backToLogin = true
                  } catch {
                     //
                  }
               } label: {
                  Text("Sign Out")
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
                 if let value = snapshot.value as? [[String: Any]] {
                    if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: []) {
                       let decoded = try JSONDecoder().decode([Student].self, from: jsonData)
                       let students: [Student] = decoded
                       let loggedInStudent = students.first(where: { $0.email == email })
                       if let studentName = loggedInStudent?.name {
                          self.studentName = studentName
                       }
                    }
                 }
              } catch {
                 print("ERROR HERE: \(error)")
              }
           }
        }
        .onChange(of: backToLogin) {
           if backToLogin {
              path.removeLast()
           }
        }
    }
}
