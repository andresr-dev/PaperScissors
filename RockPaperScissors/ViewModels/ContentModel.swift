//
//  ContentModel.swift
//  RockPaperScissors
//
//  Created by Andres camilo Raigoza misas on 11/02/22.
//

import Foundation
import SwiftUI

class ContentModel: ObservableObject {
    @Published var allOptions = Option.allCases
    @Published var computerSelection = Option.rock
    @Published var userSelection: Option?
    @Published var shouldPlayToWin = true
    @Published var score = 0
    @Published var numberOfAttempts = 10
    @Published var correctAnswer = Option.paper
    @Published var showResult = false
    @Published var milliseconds = 3000.0
    @Published var showInitialView = true
    @Published var disableButtons = true
    @Published var runCountdown = false
    @Published var gameJustOpened = true
    
    func submittAnswer(optionSelected: Option?) {
        runCountdown = false
        disableButtons = true
        // response is the duration in this animation
        // dampingFraction if 1.0 it doesn't do the bounce
        withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1.0)) {
            userSelection = optionSelected
        }
        correctAnswer = shouldPlayToWin ?
        correctAnswerPlayingToWin(optionSelected: optionSelected) :
        correctAnswerPlayingToLose(optionSelected: optionSelected)
        
        if optionSelected == correctAnswer {
            score += 1
        }
        withAnimation(.easeInOut.delay(0.4)) {
            self.showResult = true
            self.numberOfAttempts -= 1
        }
    }
    
    func continueButtonPressed() {
        withAnimation(.easeInOut) {
            self.showResult = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.milliseconds = 3000
            withAnimation(.easeInOut) {
                self.userSelection = nil
            }
        }
        
        if numberOfAttempts == 0 {
            // Game finished
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                withAnimation(.easeInOut) {
                    self.numberOfAttempts = 10
                    self.showInitialView = true
                }
                self.score = 0
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                self.shuffleAllOptions()
            }
        }
    }
    
    func initialButtonPressed() {
        withAnimation(.easeOut) {
            showInitialView = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.shuffleAllOptions()
            self.gameJustOpened = false
        }
    }
    
    func shuffleAllOptions() {
        shouldPlayToWin.toggle()
        for i in 0..<10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)/10) {
                self.allOptions.shuffle()
                self.computerSelection = self.allOptions.randomElement() ?? .paper
                if i == 9 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.disableButtons = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.runCountdown = true
                    }
                }
            }
        }
    }
    
    func correctAnswerPlayingToWin(optionSelected: Option?) -> Option {
        switch computerSelection {
        case .paper:
            return .scissors
        case .rock:
            return .paper
        case .scissors:
            return .rock
        }
    }
    
    func correctAnswerPlayingToLose(optionSelected: Option?) -> Option {
        switch computerSelection {
        case .paper:
            return .rock
        case .rock:
            return .scissors
        case .scissors:
            return .paper
        }
    }
    
    func getResultTitle() -> String {
        if gameJustOpened {
            return "Rock, Paper and Scissors"
        } else {
            if score > 8 {
                return "Great! You got \(score) of 10!"
            } else if score > 5 {
                return "Almost! You got \(score) of 10!"
            } else {
                return "Try Again! You got \(score) of 10!"
            }
        }
    }
    
    func getResultEmoji() -> String {
        if score > 8 {
            return "🥳"
        } else if score > 5 {
            return "😕"
        } else {
            return "😭"
        }
    }
    
    func countdown() {
        if runCountdown {
            if milliseconds > 0 {
                milliseconds -= 1
            } else {
                // Time is up!
                submittAnswer(optionSelected: nil)
            }
        }
    }
}
