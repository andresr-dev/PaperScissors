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
    @Published var showStartGame = false
    @Published var disableButtons = true
    var timer: Timer?
    
    func submittAnswer(optionSelected: Option?) {
        timer?.invalidate()
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
        if numberOfAttempts == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.showGameFinished = true
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.easeOut) {
                    self.userSelection = nil
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.shuffleAllOptions()
                    self.milliseconds = 3000
                }
            }
        }
    }
    
    func startGameButtonPressed() {
        withAnimation(.easeOut) {
            showStartGame = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.shuffleAllOptions()
        }
    }
    
    func shuffleAllOptions() {
        shouldPlayToWin.toggle()
        for i in 0..<10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)/10) {
                self.allOptions.shuffle()
                self.computerSelection = self.allOptions.randomElement() ?? .paper
                if i == 9 {
                    self.disableButtons = false
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
        withAnimation(.easeOut.delay(0.2)) {
            self.userSelection = nil
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.score = 0
            self.milliseconds = 3000
            withAnimation(.easeInOut(duration: 0.5)) {
                self.numberOfAttempts = 10
            }
            withAnimation(.easeIn.delay(0.6)) {
                self.showStartGame = true
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
