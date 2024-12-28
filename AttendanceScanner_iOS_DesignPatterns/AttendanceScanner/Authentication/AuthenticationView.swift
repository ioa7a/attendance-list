//
//  AuthenticationView.swift
//  AttendanceScanner
//
//  Created by Ioana Bojinca on 15.11.2024.
//

import SwiftUI

struct AuthenticationView: View {
   @State private var path = NavigationPath()
   @State private var showEmailError: Bool = false
   @State private var showPasswordError: Bool = false
   @State private var showProgressView: Bool = false
   @StateObject private var viewModel: AuthenticationViewModel = AuthenticationViewModel()

   var body: some View {
      NavigationStack(path: $path) {
         ZStack(alignment: .center) {
            ScrollView {
               scrollViewContent
            }
            
            if showProgressView {
               ProgressView(Constant.loading.rawValue)
            }
         }
         .onAppear {
            viewModel.clearData()
         }
         .onChange(of: viewModel.shouldNavigateToMainScreen) {
            if viewModel.shouldNavigateToMainScreen {
               path.append(Constant.scanAttendanceView.rawValue)
            }
         }
         .onChange(of: viewModel.email) {
            showEmailError = false
         }
         .onChange(of: viewModel.password) {
            showPasswordError = false
         }
         .navigationDestination(for: String.self) { view in
            if view == Constant.scanAttendanceView.rawValue {
               ScanAttendanceView(path: $path)
            }
         }
         .padding(.vertical, 80)
         .padding(.horizontal, 20)
      }
   }
   
   private var scrollViewContent: some View {
      VStack(alignment: .center, spacing: 20) {
         Image.logoIcon
         introTextView
         if viewModel.showAuthenticationError {
            authErrorView
         }
         textFieldsView
         Spacer()
         loginButtonView
      }
   }
   
   private var introTextView: some View {
      VStack(alignment: .center, spacing: 10) {
         Text(Constant.welcomeBack.rawValue)
            .font(.title2)
            .fontWeight(.semibold)
         
         Text(Constant.enterCredentials.rawValue)
            .font(.headline)
            .fontWeight(.regular)
      }
   }
   
   private var authErrorView: some View {
      HStack(spacing: 10) {
         Image.errorIcon
            .resizable()
            .frame(width: 40, height: 40)
         VStack {
            Text(viewModel.errorMessage)
         }
         .font(.headline)
         .fontWeight(.semibold)
      }
      .cardStyle(foregroundColor: .white,
                 cardBackgroundColor: .red,
                 verticalPadding: 20,
                 horizontalPadding: 20)
   }
   
   private var textFieldsView: some View {
      VStack(spacing: 10) {
         TextFieldWithErrorView(textContent: $viewModel.email,
                                showError: $showEmailError,
                                textContentType: .emailAddress,
                                textFieldTitle: Constant.emailTitle.rawValue,
                                errorText: Constant.emailError.rawValue)
         
         TextFieldWithErrorView(textContent: $viewModel.password,
                                showError: $showPasswordError,
                                textContentType: .password,
                                textFieldTitle: Constant.passwordTitle.rawValue,
                                errorText: Constant.passwordError.rawValue)
      }
   }
   
   private var loginButtonView: some View {
      Button(action: {
         showProgressView = true
         validateUserData()
         viewModel.signIn()
         showProgressView = false
      }, label: {
         Text(Constant.signIn.rawValue)
            .font(.headline)
      })
   }
   
   private func validateUserData() {
      if viewModel.email.isEmpty {
         withAnimation {
            showEmailError = true
         }
      }
      
      if viewModel.password.isEmpty {
         withAnimation {
            showPasswordError = true
         }
      }
   }
}
