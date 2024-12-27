//
//  AuthService.swift
//  AttendanceScanner
//
//  Created by Ioana Bojinca on 27.12.2024.
//

import Foundation
import FirebaseAuth

public final class AuthService {
   public static let shared = AuthService()
   private let auth = Auth.auth()
   private init() {}
   
   public func signIn(email: String,
                      password: String,
                      onSuccess: @escaping (() -> Void),
                      onError: @escaping ((String?) -> Void)) {
      auth.signIn(withEmail: email,
                  password: password) { authResult, error in
         if let _ = authResult {
            onSuccess()
         } else {
            DispatchQueue.main.async {
               onError(error?.localizedDescription)
            }
         }
      }
   }
   
   public func signOut(completion: @escaping ((Bool, String?) -> Void)) {
      do {
         try auth.signOut()
         completion(true, nil)
      } catch {
         print("ERROR WHILE LOGGING OUT \(error.localizedDescription)")
         completion(false, error.localizedDescription)
      }
   }
}
