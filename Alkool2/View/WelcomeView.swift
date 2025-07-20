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
    
    private let allAvatars = ["monkey", "cat", "dog", "bear", "wolf", "lion", "fox", "penguin", "crocodile", "panda", "elephant", "pig"]
    @State private var selectedAvatar: String = ""
    
    var remainingAvatars: [String] {
        let usedAvatars = players.map { $0.avatar }
        return allAvatars.filter { !usedAvatars.contains($0) }
    }
    
    var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [.deepSpaceBlue, .cosmicPurple]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .topTrailing) {
                backgroundGradient

                VStack(spacing: 20) {
                    Spacer().frame(height: 10)

                    Text("Glow")
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                        .foregroundColor(.starWhite)
                        .shadow(color: .neonMagenta.opacity(0.8), radius: 10, x: 0, y: 0)
                        .shadow(color: .neonMagenta.opacity(0.5), radius: 20, x: 0, y: 0)

                    Text("Ajoutez jusqu'à 12 joueurs :")
                        .font(.headline)
                        .foregroundColor(.lavenderMist)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(remainingAvatars, id: \.self) { avatarName in
                                Image(avatarName)
                                    .resizable().scaledToFit().frame(width: 50, height: 50)
                                    .padding(8)
                                    .background(selectedAvatar == avatarName ? .neonMagenta.opacity(0.5) : .clear)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(selectedAvatar == avatarName ? .neonMagenta : .starWhite.opacity(0.5), lineWidth: 2))
                                    .scaleEffect(selectedAvatar == avatarName ? 1.1 : 1.0)
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            selectedAvatar = avatarName
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                    }
                    .frame(height: 80)

                    HStack {
                        TextField("", text: $playerName, prompt: Text("Nom du joueur...").foregroundColor(.lavenderMist))
                            .padding(.leading, 20)
                            .foregroundColor(.starWhite)
                            .font(.system(size: 20, design: .rounded))
                            .submitLabel(.done)
                            .focused($isInputActive)
                            .onSubmit(addPlayer)
                        
                        Spacer()

                        Button(action: addPlayer) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.neonMagenta)
                        }
                        .padding(.trailing, 12)
                    }
                    .frame(height: 55)
                    .background(GlassCardBackground())
                    .padding(.horizontal, 40)
                    .disabled(remainingAvatars.isEmpty)

                    if remainingAvatars.isEmpty && players.count > 0 {
                        Text("Limite de joueurs atteinte !")
                            .font(.headline)
                            .foregroundColor(.yellow)
                    }

                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(players) { player in
                                PlayerRow(player: player) {
                                    removePlayer(player)
                                }
                                .transition(.asymmetric(insertion: .scale.combined(with: .opacity), removal: .scale.combined(with: .opacity)))
                            }
                        }
                        .padding(.horizontal)
                    }
                    .scrollContentBackground(.hidden).background(Color.clear)
                    .padding(.horizontal, 20)
                    
                    Spacer()

                    Button(action: {
                        if players.count < 2 { showPlayerAlert = true }
                        else { path.append("modeSelection") }
                    }) {
                        Text("Suivant")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.starWhite)
                            .frame(height: 60).frame(maxWidth: .infinity)
                            .background(Color.neonMagenta)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .shadow(color: .neonMagenta, radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 10)
                    .alert("Attention !", isPresented: $showPlayerAlert) {
                        Button("OK", role: .cancel) {}
                    } message: { Text("Au moins 2 joueurs sont nécessaires pour commencer.") }

                    .navigationDestination(for: String.self) { route in
                        switch route {
                        case "modeSelection":
                            ModeSelectionView(path: $path)
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
                }
                .padding()

                NavigationLink(destination: InfoView()) {
                    Image(systemName: "info.circle.fill")
                        .font(.title).foregroundColor(.starWhite.opacity(0.8)).padding()
                }
            }
        }
        .accentColor(.starWhite)
        .alert("Avertissement", isPresented: $showDisclaimer) {
            Button("Continuer") {
                UserDefaults.standard.set(true, forKey: "hasSeenDisclaimer")
            }
        } message: {
            Text("""
            Cette application est destinée à un public adulte (17+).\n\nElle contient des références à l’alcool, à la sexualité et à des substances.\n\nElle n'encourage pas leur consommation réelle.\n\nVeuillez jouer de manière responsable.
            """)
        }
        .onChange(of: players, initial: true) { _,_ in
             withAnimation {
                updateSelectedAvatar()
             }
        }
    }
    
    private func updateSelectedAvatar() { selectedAvatar = remainingAvatars.first ?? "" }

    func addPlayer() {
        let trimmedName = playerName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty, !selectedAvatar.isEmpty else { return }
        
        let newPlayer = Player(name: trimmedName, avatar: selectedAvatar)
        withAnimation(.spring()) {
            players.insert(newPlayer, at: 0)
        }
        playerName = ""
        Player.saveToUserDefaults(players)
        isInputActive = false
    }

    func removePlayer(_ player: Player) {
        withAnimation(.spring()) {
            players.removeAll { $0.id == player.id }
        }
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
                .resizable().scaledToFit().frame(width: 40, height: 40)
                .padding(4)
                .background(.ultraThinMaterial)
                .clipShape(Circle())

            Text(player.name)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.starWhite)
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.starWhite.opacity(0.7))
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(GlassCardBackground())
    }
}
