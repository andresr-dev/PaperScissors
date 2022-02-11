//
//  Image.swift
//  RockPaperScissors
//
//  Created by Andres camilo Raigoza misas on 9/02/22.
//

import Foundation
import SwiftUI

extension Image {
    func asImageTemplate() -> some View {
        resizable()
        .scaledToFit()
        .foregroundColor(Color("SkinColor"))
        .frame(maxWidth: .infinity)
        .padding()
    }
}
