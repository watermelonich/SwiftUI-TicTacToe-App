//
//  GameView.swift
//  Tic Tac Toe
//
//  Created by Nich on 9/10/23.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var game: GameService
    @EnvironmentObject var connectionManager: MPConnectionManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            if ![game.player1.isCurrent, game.player2.isCurrent].allSatisfy({ $0 == false }) {
                Text("Select a player to start")
            }
            HStack {
                Button(action: {
                    game.player1.isCurrent = true
                    if game.gameType == .peer {
                        let gameMove = MPGameMove(action: .start, playerName: game.player1.name, index: nil)
                        connectionManager.send(gameMove: gameMove)
                    }
                })
                {
                    Text(game.player1.name)
                }
                .buttonStyle(PlayerButtonStyle(isCurrent: game.player1.isCurrent))
                
                Button(action: {
                    game.player2.isCurrent = true
                    if game.gameType == .bot {
                        Task {
                            await game.deviceMove()
                        }
                    }
                    if game.gameType == .peer {
                        let gameMove = MPGameMove(action: .start, playerName: game.player2.name, index: nil)
                        connectionManager.send(gameMove: gameMove)
                    }
                }) {
                    Text(game.player2.name)
                }
                .buttonStyle(PlayerButtonStyle(isCurrent: game.player2.isCurrent))
            }
            .disabled(game.gameStarted ||
                      game.gameType == .peer &&
                      connectionManager.myPeerId.displayName !=
                      game.currentPlayer.name)
            VStack {
                HStack {
                ForEach(0...2, id: \.self) { index in
                    SquareView(index: index)
                }
            }
            HStack {
                ForEach(3...5, id: \.self) { index in
                    SquareView(index: index)
                }
            }
            HStack {
                ForEach(6...8, id: \.self) { index in
                    SquareView(index: index)
                }
            }
            Spacer()
        }
            
            VStack {
                if game.gameOver {
                    Text("Game Over")
                    if game.possibleMoves.isEmpty {
                        Text("Nobody wins")
                    } else {
                        Text("\(game.currentPlayer.name) wins!")
                    }
                    Button("New Game") {
                        game.reset()
                        if game.gameType == .peer {
                            let gameMove = MPGameMove(action: .reset, playerName: nil, index: nil)
                            connectionManager.send(gameMove: gameMove)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .font(.largeTitle)
            Spacer()
        }

        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    dismiss()
                    if game.gameType == .peer {
                        let gameMove = MPGameMove(action: .reset, playerName: nil, index: nil)
                        connectionManager.send(gameMove: gameMove)
                    }
                }) {
                    Text("End Game")
                }
                .buttonStyle(.bordered)
            }
        }
        .navigationTitle("Tic Tac Toe")
        .onAppear {
            game.reset()
            if game.gameType == .peer {
                connectionManager.setup(game: game)
            }
        }
        .inNavigationStack()
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(GameService())
            .environmentObject(MPConnectionManager(yourName: "Me"))
    }
}

struct PlayerButtonStyle: ButtonStyle {
    let isCurrent: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isCurrent ? Color.green: Color.gray)
                    .foregroundColor(.white)
            )
    }
}
