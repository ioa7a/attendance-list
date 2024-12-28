//
//  ScanAttendanceView.swift
//  AttendanceScanner
//
//  Created by Ioana Bojinca on 18.11.2024.
//

import SwiftUI

struct ScanAttendanceView: View {
   @Binding var path: NavigationPath
   @StateObject var viewModel: ScanAttendanceViewModel = ScanAttendanceViewModel()
   var body: some View {
      NavigationView {
         VStack(alignment: .center) {
            Text("Welcome back \(viewModel.studentName)!")
               .font(.title2)
               .fontWeight(.bold)
               .redacted(reason: viewModel.isLoading ? .placeholder : [])
            Spacer()
            buttonsView
         }
         .padding(.horizontal, 20)
         .padding(.vertical, 80)
      }
      .onChange(of: viewModel.backToLogin) {
         if viewModel.backToLogin {
            path.removeLast()
         }
      }
      .navigationBarBackButtonHidden(true)
   }
   
   private var buttonsView: some View {
      VStack(alignment: .center, spacing: 20) {
         NavigationLink(Constant.scanCode.rawValue) {
            QRScannerView()
         }
         
         Button {
            viewModel.logout()
         } label: {
            Text(Constant.signOut.rawValue)
         }
      }
   }
}
