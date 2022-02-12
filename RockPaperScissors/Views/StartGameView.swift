//
//  StartGameView.swift
//  RockPaperScissors
//
//  Created by Andres camilo Raigoza misas on 12/02/22.
//

import SwiftUI

struct StartGameView: View {
    @ObservedObject var vm: ContentModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.black.opacity(0.5))
                .ignoresSafeArea()
            
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(.thickMaterial)
                
                VStack {
                    Text("Rock, Paper and Scissors")
                        .font(.title2)
                        .fontWeight(.medium)
                        .minimumScaleFactor(0.7)
                    
                    Image(Option.scissors.rawValue)
                        .asImageTemplate()
                    
                    Button {
                        vm.startGameButtonPressed()
                    } label: {
                        Text("Start Game!")
                            .asCapsuleButton(color: .blue, height: 12)
                    }
                    Spacer()
                }
                .padding()
            }
            .frame(height: 220)
            .padding(.horizontal, 40)
        }
    }
}

struct StartGameView_Previews: PreviewProvider {
    static var previews: some View {
        StartGameView(vm: ContentModel())
            .preferredColorScheme(.dark)
    }
}
