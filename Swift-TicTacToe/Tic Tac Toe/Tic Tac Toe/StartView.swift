//
//  ContentView.swift
//  Tic Tac Toe
//
//  Created by Nich on 9/10/23.
//

import SwiftUI

struct StartView: View {
    
    @EnvironmentObject var game: GameService
    @StateObject var connectionManager: MPConnectionManager
    @State private var gameType: GameType = .undetermined
    @AppStorage("yourName") private var yourName = ""
    @State private var opponentName = ""
    @FocusState private var focus: Bool
    @State private var startGame = false
    @State private var changeName = false
    @State private var newName = ""
    init(yourName: String) {
        self.yourName = yourName
        _connectionManager = StateObject(wrappedValue: MPConnectionManager(yourName: yourName))
    }
    var body: some View {
        VStack {
            Picker("Select a game", selection: $gameType) {
                Text("Select Game Type").tag(GameType.undetermined)
                Text("Two Sharing device").tag(GameType.single)
                Text("Challange your device").tag(GameType.bot)
                Text("Challange a friend").tag(GameType.peer)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(lineWidth: 2))
            Text(gameType.description)
                .padding()
            
            VStack {
                switch gameType {
                case .single:
                        TextField("Opponent name", text: $opponentName)
                case .bot:
                    EmptyView()
                case .peer:
                    MPPeersView(startGame: $startGame)
                        .environmentObject(connectionManager)
                case .undetermined:
                    EmptyView()
                }
            }
            .padding()
            .textFieldStyle(.roundedBorder)
            .focused($focus)
            .frame(width: 350)
            
            if gameType != .peer {
                Button("Start Game") {
                    game.setupGame(gameType: gameType, player1Name: yourName, player2Name: opponentName)
                    focus = false
                    startGame.toggle()
                }
                .buttonStyle(.borderedProminent)
                .disabled(
                    gameType == .undetermined ||  gameType == .single &&  opponentName.isEmpty
                )
                Image("pageicon2")
                    .resizable()
                    .scaledToFit()
                Text("Your name is: \(yourName)")
                Button("Change my name") {
                    changeName.toggle()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .navigationTitle("Tic Tac Toe")
        .fullScreenCover(isPresented: $startGame, content: {
            GameView()
                .environmentObject(connectionManager)
        })
        .alert("Change Name", isPresented: $changeName, actions:{
            TextField("New name", text: $newName)
            Button("Ok", role: .destructive) {
                yourName = newName
                exit(-1)
            }
            Button("Cancel", role: .cancel) {}
        }, message: {
            Text("Tapping Ok will quit the application o you can relaunch to use your changed name.")
        })
        .inNavigationStack()
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView(yourName: "Me")
            .environmentObject(GameService())
    }
}
