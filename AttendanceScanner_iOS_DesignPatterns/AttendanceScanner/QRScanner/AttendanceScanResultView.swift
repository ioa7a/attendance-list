//
//  AttendanceScanResultView.swift
//  AttendanceScanner
//
//  Created by Ioana Bojinca on 25.12.2024.
//
import SwiftUI

struct AttendanceScanResultView: View {
   var foregroundColor: Color
   var image: Image
   var resultText: String
   
   var body: some View {
      VStack(alignment: .center, spacing: 15) {
         image
            .resizable()
            .frame(width: 50, height: 50)
         Text(resultText)
            .font(.headline)
      }
      .background(.clear)
      .foregroundStyle(.white)
      .cardStyle(foregroundColor: .white,
                 cardBackgroundColor: foregroundColor)
   }
}
