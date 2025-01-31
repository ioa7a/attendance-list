//
//  CustomShadow.swift
//  AttendanceScanner
//
//  Created by Ioana Bojinca on 27.12.2024.
//

import SwiftUI

public struct CustomShadow: ViewModifier {
   var color: Color = .black
   var radius: CGFloat = 5
   var xPoint: CGFloat = 0
   var yPoint: CGFloat = 5
   
   public func body(content: Content) -> some View {
      content
         .shadow(color: color.opacity(0.15), radius: radius, x: xPoint, y: yPoint)
   }
}

extension View {
   func customShadow(color: Color = .black,
                     radius: CGFloat = 5,
                     xPoint: CGFloat = 0,
                     yPoint: CGFloat = 5) -> some View {
      self.modifier(CustomShadow(color: color,
                                 radius: radius,
                                 xPoint: xPoint,
                                 yPoint: yPoint))
   }
}
