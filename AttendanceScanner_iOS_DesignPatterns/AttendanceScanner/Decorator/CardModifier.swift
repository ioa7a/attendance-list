//
//  CardModifier.swift
//  AttendanceScanner
//
//  Created by Ioana Bojinca on 27.12.2024.
//

import SwiftUI

struct CardStyle: ViewModifier {
   var cornerRadius: CGFloat = 20
   var foregroundColor: Color = .white
   var cardBackgroundColor: Color = .white
   var shadowColor: Color = .black
   var shadowRadius: CGFloat = 5
   var shadowX: CGFloat = 0
   var shadowY: CGFloat = 5
   var verticalPadding: CGFloat = 40
   var horizontalPadding: CGFloat = 20
   
   func body(content: Content) -> some View {
      content
         .foregroundStyle(foregroundColor)
         .padding(.vertical, verticalPadding)
         .padding(.horizontal, horizontalPadding)
         .background {
            RoundedRectangle(cornerRadius: cornerRadius,
                             style: .continuous)
            .frame(maxWidth: .infinity)
            .foregroundStyle(cardBackgroundColor)
            .customShadow(color: shadowColor,
                          radius: shadowRadius,
                          xPoint: shadowX,
                          yPoint: shadowY)
         }
   }
}

extension View {
   func cardStyle(
      cornerRadius: CGFloat = 10,
      foregroundColor: Color = .white,
      cardBackgroundColor: Color = .white,
      shadowColor: Color = .black,
      shadowRadius: CGFloat = 5,
      shadowX: CGFloat = 0,
      shadowY: CGFloat = 5,
      verticalPadding: CGFloat = 40,
      horizontalPadding: CGFloat = 20
   ) -> some View {
      self.modifier(
         CardStyle(
            cornerRadius: cornerRadius,
            foregroundColor: foregroundColor,
            cardBackgroundColor: cardBackgroundColor,
            shadowColor: shadowColor,
            shadowRadius: shadowRadius,
            shadowX: shadowX,
            shadowY: shadowY,
            verticalPadding: verticalPadding,
            horizontalPadding: horizontalPadding
         )
      )
   }
}
