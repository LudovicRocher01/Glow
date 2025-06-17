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

    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .topTrailing) {
                // Fond
                Color(red: 7/255, green: 5/255, blue: 77/255)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Spacer().frame(height: 30)

                    // Titre
                    Text("Alkool")
                        .font(.custom("ChalkboardSE-Bold", size: 34))
                        .foregroundColor(.white)
                        .padding(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white, lineWidth: 2)
                        )

                    // Label
                    Text("Ajoutez un joueur :")
                        .foregroundColor(.white)

                    // Champ texte + bouton "+"
                    HStack(spacing: 10) {
                        TextField("Nom du joueur", text: $playerName)
                            .textFieldStyle(.roundedBorder)

                        Button(action: addPlayer) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal)

                    // Liste des joueurs
                    List {
                        ForEach(players, id: \.id) { player in
                            HStack {
                                Text(player.name)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                Button(action: {
                                    removePlayer(player)
                                }) {
                                    Text("-")
                                        .font(.title2)
                                        .foregroundColor(.red)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(hex: "#FAEBD7"), lineWidth: 2)
                            )
                            .listRowBackground(Color.clear)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)

                    // Bouton Suivant
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

                // Bouton Info
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

    // MARK: - Fonctions
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

