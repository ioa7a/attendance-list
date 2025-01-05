//
//  AuthenticationViewModel.swift
//  AttendanceScanner
//
//  Created by Ioana Bojinca on 23.12.2024.
//

import Foundation
import SwiftUI

class AuthenticationViewModel: ObservableObject {
   @Published var email: String = ""
   @Published var password: String = ""
   @Published var showAuthenticationError: Bool = false
   @Published var shouldNavigateToMainScreen: Bool = false
   @Published var errorMessage: String = Constant.errorText.rawValue

   func clearData() {
      self.email = ""
      self.password = ""
   }

   func signIn() {
      guard !email.isEmpty && !password.isEmpty else {
         return
      }
      shouldNavigateToMainScreen = false
      showAuthenticationError = false
      performLogIn()
   }

   private func performLogIn() {
      AuthService.shared.signIn(email: self.email,
                                password: self.password) {
         UserDefaultsManager.shared.setStudentEmail(email: self.email)
         self.shouldNavigateToMainScreen = true
      } onError: { error in
         self.updateViewForError(with: error)
      }
   }

   private func updateViewForError(with errorMessage: String?) {
      withAnimation {
         self.errorMessage = errorMessage ?? Constant.errorText.rawValue
         self.showAuthenticationError = true
         self.shouldNavigateToMainScreen = false
      }
   }
}
