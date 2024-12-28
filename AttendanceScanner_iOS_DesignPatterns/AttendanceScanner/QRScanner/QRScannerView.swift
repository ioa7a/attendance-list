//
//  QRScannerView.swift
//  AttendanceScanner
//
//  Created by Ioana Bojinca on 16.11.2024.
//

import SwiftUI

struct QRScannerView: View {
   @State var scanResult = Constant.noQrCode.rawValue
   @StateObject var viewModel: QRScannerViewModel = QRScannerViewModel()

   var body: some View {
      ZStack(alignment: .bottom) {
         QRScanner(result: $scanResult)
         VStack {
            if viewModel.showProgressView {
               ProgressView(Constant.loading.rawValue)
            }
            
            if viewModel.attendanceValidated {
               AttendanceScanResultView(foregroundColor: viewModel.showAttendanceError ? .red : .blue,
                                        image: viewModel.scanResultViewLabelImageName,
                                        resultText: viewModel.scanResultViewLabelText)
            }
            
            scanValueView
         }
      }
      .background(.clear)
      .onChange(of: scanResult) {
         viewModel.scanAttendance(scanResult: scanResult)
      }
   }
   
   private var scanValueView: some View {
      Text(scanResult)
         .padding()
         .background(.black)
         .foregroundColor(.white)
         .padding(.bottom)
   }
}
