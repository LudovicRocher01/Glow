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


    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .topTrailing) {
                Color(red: 7/255, green: 5/255, blue: 77/255)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Spacer().frame(height: 30)

                    Text("Alkool")
                        .font(.custom("ChalkboardSE-Bold", size: 36))
                        .foregroundColor(.white)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white, lineWidth: 3)
                        )
                        .padding(.bottom, 12)

                    Text("Ajoutez un joueur :")
                        .font(.custom("Marker Felt", size: 20))
                        .foregroundColor(.white)

                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.red, lineWidth: 2)
                            .background(Color.red.opacity(0.5))
                            .cornerRadius(12)
                            .frame(height: 50)

                        HStack {
                            TextField("", text: $playerName)
                                .padding(.leading, 12)
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .medium))
                                .submitLabel(.done)
                                .focused($isInputActive)
                                .onSubmit {
                                    addPlayer()
                                    isInputActive = true
                                }


                            Spacer()

                            Button(action: addPlayer) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.red)
                                    .padding(.trailing, 12)
                            }
                        }
                    }
                    .frame(maxWidth: 300)
                    .padding(.bottom, 20)



                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(players, id: \.id) { player in
                                PlayerRow(player: player) {
                                    removePlayer(player)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    .scrollContentBackground(.hidden)
                    .background(Color.clear)


                    Button(action: {
                        path.append("settings")
                    }) {
                        Text("Suivant")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white, lineWidth: 2)
                            )
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
                        .font(.title2)
                        .foregroundColor(.red)
                        .padding()
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
    }

    func addPlayer() {
        let trimmed = playerName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        players.insert(Player(name: trimmed), at: 0)
        playerName = ""
        Player.saveToUserDefaults(players)
    }

    func removePlayer(_ player: Player) {
        players.removeAll { $0.id == player.id }
        Player.saveToUserDefaults(players)
    }
    
    
}

struct PlayerRow: View {
    let player: Player
    let onRemove: () -> Void

    var body: some View {
        HStack {
            Text(player.name)
                .font(.custom("Marker Felt", size: 18))
                .foregroundColor(.white)
            Spacer()
            Button(action: onRemove) {
                Text("-")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(hex: "#FAEBD7"), lineWidth: 2)
        )
    }
}
