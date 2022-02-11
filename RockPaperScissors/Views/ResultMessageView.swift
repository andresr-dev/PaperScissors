//
//  ResultMessage.swift
//  RockPaperScissors
//
//  Created by Andres camilo Raigoza misas on 10/02/22.
//

import SwiftUI

struct ResultMessageView: View {
    @ObservedObject var vm: ContentModel
    
    var userAnsweredRight: Bool {
        vm.userSelection == vm.correctAnswer
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            background
            VStack(alignment: .leading, spacing: 17) {
                label
                VStack(alignment: .leading, spacing: 5) {
                    answerText
                    scoreText
                }
                Spacer(minLength: 0)
                button
            }
            .padding()
            .padding(.bottom, 30)
        }
        .frame(height: 225)
    }
}

struct ResultMessage_Previews: PreviewProvider {
    static var previews: some View {
        ResultMessageView(vm: ContentModel())
            //.preferredColorScheme(.dark)
    }
}

extension ResultMessageView {
    
    private var background: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(.thickMaterial)
            //.shadow(color: .primary.opacity(0.3), radius: 5, x: 0, y: 0)
    }
    
    private var label: some View {
        Label(
            userAnsweredRight ? "Correct!" :
                vm.milliseconds == 0 ? "Time is Up!" : "Wrong!",
            systemImage: userAnsweredRight ?
            "checkmark.circle.fill" :
                vm.milliseconds == 0 ? "clock.fill" : "xmark.circle.fill"
        )
            .font(.system(size: 22, weight: .medium, design: .default))
            .foregroundColor(
                userAnsweredRight ?
                Color.Theme.green : Color.Theme.red
            )
    }
    
    private var answerText: some View {
        HStack {
            Text("Correct Answer:")
                .font(.callout)
                .foregroundColor(.secondary)
            
            Text(vm.correctAnswer.rawValue.capitalized)
                .font(.headline)
        }
    }
    
    private var scoreText: some View {
        HStack {
            Text("Score:")
                .font(.callout)
                .foregroundColor(.secondary)
            
            Text(vm.score, format: .number)
                .font(.headline)
        }
    }
    private var info: some View {
        HStack {
            Text("Correct Answer:")
                .font(.callout)
                .foregroundColor(.secondary)
            
            Text(vm.correctAnswer.rawValue.capitalized)
                .font(.headline)
            
            Text("/")
                .font(.callout)
                .foregroundColor(.secondary)
            
            Text("Score:")
                .font(.callout)
                .foregroundColor(.secondary)
            
            Text(vm.score, format: .number)
                .font(.headline)
        }
    }
    private var button: some View {
        Button {
            vm.continueButtonPressed()
        } label: {
            Text(vm.numberOfAttempts > 0 ?
                 "Continue" : "Finish")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .background(
                    userAnsweredRight ?
                    Color.Theme.green : Color.Theme.red
                )
                .clipShape(Capsule())
        }
    }
}
