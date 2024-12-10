//
//  AuthenticationView.swift
//  AttendanceScanner
//
//  Created by Ioana Bojinca on 15.11.2024.
//

import SwiftUI
import FirebaseAuth

struct AuthenticationView: View {
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
                        showEmailError = true
                    }
                    
                    if password.isEmpty {
                        showPasswordError = true
                    }
                    
                    if !email.isEmpty && !password.isEmpty {
                        print("Will login")
                        showAuthenticationError = false
                        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                            if let authResult = authResult {
                                print("_________ authResult \(authResult.user) \(authResult.credential)")
                                path.append("ScanAttendanceView")
                            } else {
                                showAuthenticationError = true
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
                    ScanAttendanceView()
                }
            }
            .padding(.vertical, 80)
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    AuthenticationView()
}

struct StudentModel {
    var id: String
    var email: String
    var name: String
    var classes: [ClassModel]
}

struct Professor {
    var id: String
    var email: String
    var name: String
    var className: String
}

struct ClassModel {
    var id: String
    var name: String
    var professor: Professor
}

struct Attendance {
    var studentName: String
    var studentEmail: String
    var className: String
    var timestamp: Date
}
