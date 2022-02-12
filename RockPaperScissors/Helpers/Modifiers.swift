//
//  Modifiers.swift
//  RockPaperScissors
//
//  Created by Andres camilo Raigoza misas on 12/02/22.
//

import Foundation
import SwiftUI

struct CapsuleButton: ViewModifier {
    let color: Color
    let height: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .padding(.vertical, height)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(color)
            .clipShape(Capsule())
    }
}
