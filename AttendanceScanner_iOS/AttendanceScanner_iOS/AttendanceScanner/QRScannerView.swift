//
//  QRScannerView.swift
//  AttendanceScanner
//
//  Created by Ioana Bojinca on 16.11.2024.
//

import SwiftUI
import Firebase
import FirebaseDatabase

struct QRScannerView: View {
   @State private var studentName = "Ion Popescu2"
    private let defaultValue = "No QR code detected"
    @State var scanResult = "No QR code detected"
    @State private var attendanceValidated: Bool = false
    @State private var showProgressView: Bool = false
   @StateObject private var viewModel: QRScannerViewModel = QRScannerViewModel()
    var body: some View {
        ZStack(alignment: .bottom) {
            QRScanner(result: $scanResult)
            VStack {
                
                if showProgressView {
                    ProgressView()
                }
                
                withAnimation(.easeInOut(duration: 1)) {
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 200, height: 200, alignment: .center)
                            .foregroundStyle(.blue)
                            .background(.clear)
                        VStack(spacing: 15) {
                            Image(systemName: "checkmark")
                                .resizable()
                                .frame(width: 50, height: 50)
                            Text("Attendance Validated!")
                                .font(.headline)
                        }
                        .background(.clear)
                        .foregroundStyle(.white)
                    }
                    .opacity(attendanceValidated ? 1 : 0)
                    .background(.clear)
                    .padding(.vertical, 40)
                }
                
                Text(scanResult)
                    .padding()
                    .background(.black)
                    .foregroundColor(.white)
                    .padding(.bottom)
            }
        }
        .background(.clear)
        .onChange(of: scanResult) {
            showProgressView = true
            if scanResult != defaultValue {
               viewModel.setStudentAttendance(for: scanResult,
                                              studentName: studentName)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    showProgressView = false
//                    attendanceValidated = true
//                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showProgressView = false
                    attendanceValidated = false
                }
            }
        }
    }
}

#Preview {
    QRScannerView()
}

class QRScannerViewModel: ObservableObject {
   func setStudentAttendance(for attendanceId: String?, studentName: String) {
      if let attendanceId = attendanceId {
         var ref: DatabaseReference!
         ref = Database.database().reference()
//         ref.child("").updateChildValues(<#T##values: [AnyHashable : Any]##[AnyHashable : Any]#>)
         ref.child("Attendance").child("\(attendanceId)/students").updateChildValues(["\(studentName)": true])
      }
   }
}

