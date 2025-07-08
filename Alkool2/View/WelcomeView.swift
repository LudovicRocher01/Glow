//
//  WelcomeView.swift
//  Alkool2
//
//  Created by Ludovic Rocher on 17/06/2025.
//

import SwiftUI

struct WelcomeView: View {
    @State private var playerName: String = ""
    @State private var players: [Player] = Player.loadFromUserDefaults()
    @State private var showDisclaimer = !UserDefaults.standard.bool(forKey: "hasSeenDisclaimer")
    @State private var path = NavigationPath()
    @FocusState private var isInputActive: Bool
    @State private var showPlayerAlert = false
    @State private var gameID = 0
    
    private let allAvatars = ["monkey", "cat", "dog", "bear", "wolf", "lion", "fox", "penguin", "crocodile", "panda"]
    @State private var selectedAvatar: String = ""
    
    var remainingAvatars: [String] {
        let usedAvatars = players.map { $0.avatar }
        return allAvatars.filter { !usedAvatars.contains($0) }
    }

    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .topTrailing) {
                Color.backgroundColor
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Spacer().frame(height: 30)

                    Text("Glou")
                        .font(.custom("ChalkboardSE-Bold", size: 36))
                        .foregroundColor(.white)
                        .padding(.vertical, 2).padding(.horizontal, 10)
                        .background(RoundedRectangle(cornerRadius: 16).stroke(Color.white, lineWidth: 3))
                        .padding(.bottom, 12)

                    Text("Ajoutez un joueur :")
                        .font(.custom("Marker Felt", size: 20))
                        .foregroundColor(.white)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(remainingAvatars, id: \.self) { avatarName in
                                Image(avatarName)
                                    .resizable().scaledToFit().frame(width: 50, height: 50)
                                    .padding(5)
                                    .background(selectedAvatar == avatarName ? Color.buttonRed.opacity(0.8) : Color.clear)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: selectedAvatar == avatarName ? 2 : 0))
                                    .onTapGesture { selectedAvatar = avatarName }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 60)

                    ZStack {
                        RoundedRectangle(cornerRadius: 12).stroke(Color.buttonRed, lineWidth: 2)
                            .background(Color.buttonRed.opacity(0.6)).cornerRadius(12).frame(height: 50)

                        HStack {
                            TextField("", text: $playerName, prompt: Text("Nom du joueur...").foregroundColor(.white.opacity(0.6)))
                                .padding(.leading, 12).foregroundColor(.white)
                                .font(.custom("Marker Felt", size: 20))
                                .submitLabel(.done).focused($isInputActive).onSubmit(addPlayer)
                            
                            Spacer()

                            Button(action: addPlayer) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable().frame(width: 24, height: 24)
                                    .foregroundColor(.red).padding(.trailing, 12)
                            }
                        }
                    }
                    .frame(maxWidth: 300).padding(.bottom, 20)
                    .disabled(remainingAvatars.isEmpty)

                    if remainingAvatars.isEmpty && players.count > 0 {
                        Text("Limite de joueurs atteinte !")
                            .font(.custom("Marker Felt", size: 16))
                            .foregroundColor(.yellow)
                    }

                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(players) { player in
                                PlayerRow(player: player) {
                                    removePlayer(player)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .scrollContentBackground(.hidden).background(Color.clear)

                    Button(action: {
                        if players.count < 2 { showPlayerAlert = true }
                        else { path.append("settings") }
                    }) {
                        Text("Suivant")
                            .font(.system(size: 26, weight: .bold)).foregroundColor(.white)
                            .frame(height: 60).frame(maxWidth: .infinity)
                            .background(Color.buttonRed).cornerRadius(18)
                            .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.white, lineWidth: 2))
                            .padding(.horizontal, 30)
                    }
                    .alert("Attention !", isPresented: $showPlayerAlert) {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text("Au moins 2 joueurs sont nécessaires pour commencer.")
                    }

                    .navigationDestination(for: String.self) { route in
                        switch route {
                        case "settings":
                            SettingsView(path: $path, players: players)
                        case "numberView":
                            let themes = UserDefaults.standard.array(forKey: "selectedThemes") as? [String] ?? []
                            NumberView(path: $path, players: players, selectedThemes: themes)
                        case "gameView":
                            let themes = UserDefaults.standard.array(forKey: "selectedThemes") as? [String] ?? []
                            let count = UserDefaults.standard.integer(forKey: "savedQuestionCount")
                            GameView(path: $path, players: players, selectedThemes: themes, totalQuestions: count)
                                .id(gameID)
                            
                        case "endGame":
                            EndGameView(path: $path, onReplay: incrementGameID)
                            
                        default:
                            EmptyView()
                        }
                    }
                    .padding(.horizontal)
                    Spacer()
                }
                .padding()

                NavigationLink(destination: InfoView()) {
                    Image(systemName: "info.circle.fill")
                        .font(.title).foregroundColor(.red).padding()
                }
            }
        }
        .alert("Avertissement", isPresented: $showDisclaimer) {
            Button("Continuer") {
                UserDefaults.standard.set(true, forKey: "hasSeenDisclaimer")
            }
        } message: {
            Text("""
            Cette application est destinée à un public adulte (17+).\n\nElle contient des références à l’alcool, à la sexualité et à des substances.\n\nElle n'encourage pas leur consommation réelle.\n\nVeuillez jouer de manière responsable.
            """)
        }
        .onChange(of: players, initial: true) {
            updateSelectedAvatar()
        }
    }
    
    private func updateSelectedAvatar() {
        selectedAvatar = remainingAvatars.first ?? ""
    }

    func addPlayer() {
        let trimmedName = playerName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        guard !selectedAvatar.isEmpty else { return }
        
        let newPlayer = Player(name: trimmedName, avatar: selectedAvatar)
        players.insert(newPlayer, at: 0)
        playerName = ""
        Player.saveToUserDefaults(players)
        
        isInputActive = true
    }

    func removePlayer(_ player: Player) {
        players.removeAll { $0.id == player.id }
        Player.saveToUserDefaults(players)
    }
    
    func incrementGameID() {
        gameID += 1
    }
}


struct PlayerRow: View {
    let player: Player
    let onRemove: () -> Void

    var body: some View {
        HStack {
            Image(player.avatar)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .clipShape(Circle())

            Text(player.name)
                .font(.custom("Marker Felt", size: 18))
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "minus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(hex: "#FAEBD7"), lineWidth: 2)
        )
    }
}
