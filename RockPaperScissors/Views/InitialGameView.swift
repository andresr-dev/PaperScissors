//
//  StartGameView.swift
//  RockPaperScissors
//
//  Created by Andres camilo Raigoza misas on 12/02/22.
//

import SwiftUI

struct InitialGameView: View {
    @ObservedObject var vm: ContentModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.thinMaterial)
                .ignoresSafeArea()
            
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(.black)
                
                VStack {
                    title
                    Spacer(minLength: 0)
                    image
                    Spacer(minLength: 0)
                    button
                }
                .padding()
                .padding(.vertical, 5)
            }
            .padding(.horizontal, 30)
            .frame(height: 220)
        }
    }
}

struct InitialGameView_Previews: PreviewProvider {
    static var previews: some View {
        InitialGameView(vm: ContentModel())
            .preferredColorScheme(.dark)
    }
}

extension InitialGameView {
    
    private var title: some View {
        Text(vm.getResultTitle())
            .font(vm.gameJustOpened ? .title2 : .title3)
            .fontWeight(.medium)
            .foregroundColor(.white)
    }
    
    @ViewBuilder private var image: some View {
        if vm.gameJustOpened {
            Image(Option.scissors.rawValue)
                .asImageTemplate()
        } else {
            Text(vm.getResultEmoji())
                .font(.system(size: 55))
        }
    }
    
    private var button: some View {
        Button {
            vm.initialButtonPressed()
        } label: {
            Text(vm.gameJustOpened ? "Start Game!" : "Play Again!")
                .asCapsuleButton(color: .blue, height: 12)
        }
    }
}
