//
//  TextFieldWithErrorView.swift
//  AttendanceScanner
//
//  Created by Ioana Bojinca on 25.12.2024.
//

import SwiftUI

struct TextFieldWithErrorView: View {
   @Binding var textContent: String
   @Binding var showError: Bool
   var textContentType: UITextContentType
   var textFieldTitle: String
   var errorText: String
   
   var body: some View {
      VStack(alignment: .leading,
             spacing: 5) {
         Text(textFieldTitle)
            .font(.callout)
            .fontWeight(.semibold)
         if textContentType == .password {
            SecureField(textFieldTitle,
                        text: $textContent)
            .textFieldStyle(.roundedBorder)
            .textContentType(textContentType)
         } else {
            TextField(textFieldTitle,
                        text: $textContent)
            .textFieldStyle(.roundedBorder)
            .textContentType(textContentType)
         }
         
         if showError {
            Text(errorText)
               .font(.caption)
               .foregroundStyle(Color.red)
         }
      }
   }
}
