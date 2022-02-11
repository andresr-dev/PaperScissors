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
    @Published var showGameFinished = false
    @Published var milliseconds = 3000.0
    @Published var shuffling = false
    var timer: Timer?
    
    func submittAnswer(optionSelected: Option?) {
        timer?.invalidate()
        withAnimation(.easeInOut) {
            numberOfAttempts -= 1
        }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5)) {
            userSelection = optionSelected
        }
        correctAnswer = shouldPlayToWin ?
        correctAnswerPlayingToWin(optionSelected: optionSelected) :
        correctAnswerPlayingToLose(optionSelected: optionSelected)
        
        if optionSelected == correctAnswer {
            score += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.easeInOut) {
                self.showResult = true
            }
        }
    }
    
    func continueButtonPressed() {
        withAnimation(.easeInOut) {
            self.showResult = false
        }
        if numberOfAttempts == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.showGameFinished = true
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.shuffleAllOptions()
                self.milliseconds = 3000
                withAnimation(.easeInOut) {
                    self.userSelection = nil
                }
            }
        }
    }
    
    func shuffleAllOptions() {
        shouldPlayToWin = Bool.random()
        shuffling = true
        for i in 0..<10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)/10) {
                self.allOptions.shuffle()
                self.computerSelection = self.allOptions.randomElement() ?? .paper
                if i == 9 {
                    self.shuffling = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.fireTimer()
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
    
    func resetGame() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.score = 0
            self.milliseconds = 3000
            self.shuffleAllOptions()
            withAnimation(.easeInOut(duration: 0.5)) {
                self.numberOfAttempts = 10
            }
            withAnimation(.easeInOut) {
                self.userSelection = nil
            }
        }
    }
    
    func getAlertMessage() -> String {
        if score > 8 {
            return "Great! 🥳 You got \(score) of 10!"
        } else if score > 5 {
            return "Almost! 😐 You got \(score) of 10!"
        } else {
            return "Try Again! 😔 You got \(score) of 10!"
        }
    }
    
    func fireTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { _ in
            self.countdown()
        }
    }
    
    func countdown() {
        if milliseconds > 0 {
            milliseconds -= 1
        } else {
            timer?.invalidate()
        }
    }
}
