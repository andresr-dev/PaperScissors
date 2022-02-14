//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Andres camilo Raigoza misas on 9/02/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = ContentModel()
    let timer = Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
        
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                HStack(alignment: .center) {
                    timerView
                    Spacer()
                    shouldWindText
                    Spacer()
                    AttemptsProgress
                }
                .padding()
                computerSelectionImage
                divider
                userSelectionImage
                Spacer(minLength: 0)
                scoreText
                buttons
            }
            .padding(.bottom, 30)
            if vm.showResult {
                ResultMessageView(vm: vm)
                    .zIndex(1)
                    .transition(.move(edge: .bottom))
            }
            if vm.showInitialView {
                InitialGameView(vm: vm)
                    .zIndex(1)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .leading))
                    )
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .onReceive(timer) { _ in
            vm.countdown()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}

extension ContentView {
    
    private var shouldWindText: some View {
        Text(vm.shouldPlayToWin ? "Play to Win!" : "Play to Lose!")
            .font(.title)
            .fontWeight(.medium)
    }
    
    private var timerView: some View {
        ZStack {
            Capsule()
                .stroke(vm.milliseconds == 0 ? Color.Theme.red : .primary, lineWidth: 1)
            
            Text(vm.milliseconds.asTimerFormatted())
                .font(.callout)
                .fontWeight(.medium)
                .foregroundColor(vm.milliseconds == 0 ? .Theme.red : .primary)
                .frame(width: 40, alignment: .leading)
                .offset(x: 1.5, y: 0)
        }
        .frame(width: 60, height: 30)
    }
    
    private var AttemptsProgress: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.25), lineWidth: 3)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(vm.numberOfAttempts)/10)
                .rotation(.degrees(-90))
                .stroke(.green, style: .init(lineWidth: 3, lineCap: .round))
            
            Text(vm.numberOfAttempts, format: .number)
                .font(.title2)
                .fontWeight(.medium)
                .animation(.none, value: vm.numberOfAttempts)
        }
        .frame(width: 60, height: 55)
    }
    
    private var computerSelectionImage: some View {
        Image(vm.computerSelection.rawValue)
            .asImageTemplate()
            .frame(height: 190)
            .overlay(alignment: .topLeading) {
                Image(systemName: "iphone")
                    .font(.system(size: 32, weight: .thin, design: .default))
                    .padding(.leading)
            }
    }
    
    private var divider: some View {
        Capsule()
            .foregroundColor(.primary)
            .frame(height: 0.7)
            .padding()
    }
    
    private var userSelectionImage: some View {
        ZStack {
            if vm.userSelection == nil {
                Rectangle()
                    .fill(.clear)
                    .frame(maxWidth: .infinity)
            }
            if let userSelection = vm.userSelection?.rawValue {
                Image(userSelection)
                    .asImageTemplate()
                    .transition(.scale)
            }
        }
        .frame(height: 190)
        .overlay(alignment: .topLeading) {
            Image(systemName: "person")
                .font(.system(size: 32, weight: .thin, design: .default))
                .padding(.leading)
        }
    }
    
    private var scoreText: some View {
        Text("Score: \(vm.score)")
            .font(.title2)
            .fontWeight(.medium)
            .padding(.bottom)
    }
    
    private var buttons: some View {
        HStack(spacing: 30) {
            ForEach(vm.allOptions, id: \.self) { option in
                Button {
                    vm.submittAnswer(optionSelected: option)
                } label: {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(lineWidth: 0.8)
                        .frame(width: 100, height: 100)
                        .overlay {
                            Image(option.rawValue)
                                .asImageTemplate()
                        }
                }
                .tint(.primary)
                .disabled(vm.disableButtons)
            }
        }
        .padding(.bottom)
    }
}
