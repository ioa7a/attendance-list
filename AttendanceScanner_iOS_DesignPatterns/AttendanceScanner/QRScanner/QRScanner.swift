//
//  QRScanner.swift
//  AttendanceScanner
//
//  Created by Ioana Bojinca on 23.12.2024.
//

import SwiftUI
import AVFoundation

struct QRScanner: UIViewControllerRepresentable {
   @Binding var result: String
   func makeUIViewController(context: Context) -> QRScannerController {
      let controller = QRScannerController()
      controller.delegate = context.coordinator
      return controller
   }
   
   func updateUIViewController(_ uiViewController: QRScannerController, context: Context) {}
   
   class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
      @Binding var scanResult: String
      
      init(_ scanResult: Binding<String>) {
         self._scanResult = scanResult
      }
      
      func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
         // Check if the metadataObjects array is not nil and it contains at least one object.
         if metadataObjects.count == 0 {
            scanResult = Constants.noQrCode
            return
         }
         
         // Get the metadata object.
         if let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject,
            metadataObj.type == AVMetadataObject.ObjectType.qr,
            let result = metadataObj.stringValue {
            scanResult = result
         }
      }
   }
   
   func makeCoordinator() -> Coordinator {
      Coordinator($result)
   }
}
