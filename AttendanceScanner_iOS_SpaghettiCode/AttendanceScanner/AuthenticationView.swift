//
//  AuthenticationView.swift
//  AttendanceScanner
//
//  Created by Ioana Bojinca on 15.11.2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct AuthenticationView: View {
   @State var studentName: String = ""
   @State var email: String = ""
   @State var password: String = ""
   @State var shouldNavigateToMainScreen: Bool = false
   @State private var path = NavigationPath()
   @State private var showEmailError: Bool = false
   @State private var showPasswordError: Bool = false
   @State private var showAuthenticationError: Bool = false
   
   var body: some View {
      NavigationStack(path: $path) {
         VStack(alignment: .center, spacing: 40) {
            Image("logo-icon")
            
            VStack(alignment: .center, spacing: 10) {
               Text("Welcome back!")
                  .font(.title2)
                  .fontWeight(.semibold)
               
               Text("Please enter your credentials to sign in.")
                  .font(.headline)
                  .fontWeight(.regular)
            }
            
            if showAuthenticationError {
               withAnimation {
                  ZStack {
                     RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.red)
                     HStack(spacing: 10) {
                        Image(systemName: "exclamationmark.triangle")
                           .resizable()
                           .frame(width: 40, height: 40)
                        VStack {
                           Text("Something went wrong.")
                           Text("Please try again later.")
                        }
                        .font(.headline)
                        .fontWeight(.semibold)
                     }
                  }
               }
            }
            
            VStack(alignment: .leading, spacing: 5) {
               Text("Email")
                  .font(.callout)
                  .fontWeight(.semibold)
               TextField("Email",
                         text: $email)
               .textFieldStyle(.roundedBorder)
               .textContentType(.emailAddress)
               
               if showEmailError {
                  Text("Please enter a valid email address.")
                     .font(.caption)
                     .foregroundStyle(Color.red)
               }
            }
            
            VStack(alignment: .leading, spacing: 5) {
               Text("Password")
                  .font(.callout)
                  .fontWeight(.semibold)
               SecureField("Password",
                           text: $password)
               .textFieldStyle(.roundedBorder)
               .textContentType(.password)
               
               if showPasswordError {
                  Text("Please enter your password.")
                     .font(.caption)
                     .foregroundStyle(Color.red)
               }
            }
            
            Spacer()
            Button(action: {
               // perform login action here
               if email.isEmpty {
                  withAnimation {
                     showEmailError = true
                  }
               }

               if password.isEmpty {
                  withAnimation {
                     showPasswordError = true
                  }
               }
               
               if !email.isEmpty && !password.isEmpty {
                  print("Will login")
                  withAnimation {
                     showEmailError = false
                     showPasswordError = false
                     showAuthenticationError = false
                  }
                  Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                     if let _ = authResult {
                        // Get student name from datebase
                        var ref: DatabaseReference!
                        ref = Database.database().reference()
                        Task {
                           let snapshot = try await ref.child("Students").getData()
                           do {
                              guard let value = snapshot.value as? [[String: Any]] else {
                                 print("_______ error")
                                 return
                              }

                              let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                              let decoded = try JSONDecoder().decode([Student].self, from: jsonData)
                              let students: [Student] = decoded
                              let loggedInStudent = students.first(where: {$0.email == email })
                              studentName = loggedInStudent?.name ?? "N/A"
                           } catch {
                               print("ERROR HERE: \(error)")
                           }
                        }
                        path.append("ScanAttendanceView")
                     } else {
                        withAnimation {
                           showAuthenticationError = true
                        }
                     }
                  }
               }
            }, label: {
               Text("Sign In")
                  .font(.headline)
            })
         }
         .navigationDestination(for: String.self) { view in
            if view == "ScanAttendanceView" {
               ScanAttendanceView(email: email)
            }
         }
         .padding(.vertical, 80)
         .padding(.horizontal, 20)
      }
   }
}

struct Student: Codable {
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
#Preview {
   AuthenticationView()
}
