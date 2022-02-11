//
//  Double.swift
//  RockPaperScissors
//
//  Created by Andres camilo Raigoza misas on 11/02/22.
//

import Foundation

extension Double {
    func asTimerFormatted() -> String {
        let seconds = self/1_000.0
        let formatted = String(format: "%.2f", seconds)
        return formatted.replacingOccurrences(of: ".", with: ":")
    }
}
