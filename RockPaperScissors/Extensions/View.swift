//
//  View.swift
//  RockPaperScissors
//
//  Created by Andres camilo Raigoza misas on 12/02/22.
//

import Foundation
import SwiftUI

extension View {
    func asCapsuleButton(color: Color, height: CGFloat) -> some View {
        modifier(CapsuleButton(color: color, height: height))
    }
}
