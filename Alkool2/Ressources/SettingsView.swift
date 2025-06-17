//
//  SettingsView.swift
//  Alkool2
//
//  Created by Ludovic Rocher on 17/06/2025.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var path: NavigationPath
    var players: [Player]

    private let themes: [(String, String)] = [
        ("Catégorie", "folder.fill"),
        ("Je n'ai jamais", "hand.raised.fill"),
        ("Culture G", "book.fill"),
        ("Vrai ou Faux", "checkmark.circle.fill"),
        ("Qui pourrait", "questionmark.circle.fill"),
        ("Jeux", "gamecontroller.fill"),
        ("Débats", "bubble.left.and.bubble.right.fill"),
        ("Autres", "sparkles")
    ]

    @State private var selectedThemes: Set<String> = Set(UserDefaults.standard.array(forKey: "selectedThemes") as? [String] ?? [])

    var body: some View {
        ZStack {
            Color(red: 7/255, green: 5/255, blue: 77/255)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // Bouton Retour en haut à gauche
                HStack {
                    Button(action: { dismiss() }) {
                        Text("Retour")
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.red)
                            .cornerRadius(12)
                    }
                    Spacer()
                }
                .padding(.horizontal)

                Spacer().frame(height: 10)

                // Titre Alkool centré
                Text("Alkool")
                    .font(.custom("ChalkboardSE-Bold", size: 34))
                    .foregroundColor(.white)
                    .padding(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white, lineWidth: 2)
                    )

                // Label d'instructions
                Text("Veuillez choisir les thèmes avec lesquels vous voulez jouer :")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // Grille des thèmes sélectionnables
                LazyVGrid(columns: [GridItem(), GridItem()], spacing: 15) {
                    ForEach(themes, id: \.0) { theme in
                        ThemeCell(themeName: theme.0, iconName: theme.1, isSelected: selectedThemes.contains(theme.0))
                            .contentShape(Rectangle()) // permet que tout le rectangle soit cliquable
                            .onTapGesture {
                                toggleSelection(theme.0)
                            }
                    }
                }
                .padding(.horizontal)



                Spacer()

                // Bouton Suivant en bas
                Button(action: {
                    path.append("numberView")
                }) {
                    Text("Suivant")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(12)
                }

                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .padding(.top, 20)
        }
        .navigationBarHidden(true)
        .onAppear {
            loadSelectedThemes()
        }
    }

    // Gestion des sélections
    private func toggleSelection(_ theme: String) {
        if selectedThemes.contains(theme) {
            selectedThemes.remove(theme)
        } else {
            selectedThemes.insert(theme)
        }
        saveSelectedThemes()
    }

    private func saveSelectedThemes() {
        UserDefaults.standard.set(Array(selectedThemes), forKey: "selectedThemes")
    }

    private func loadSelectedThemes() {
        if let saved = UserDefaults.standard.array(forKey: "selectedThemes") as? [String] {
            selectedThemes = Set(saved)
        } else {
            selectedThemes = Set(themes.map { $0.0 })
        }
    }
}

// Cellule de thème personnalisée
struct ThemeCell: View {
    let themeName: String
    let iconName: String
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: iconName)
                .font(.title)
                .foregroundColor(isSelected ? .green : .white)
            Text(themeName)
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 90)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.green : Color.white, lineWidth: 2)
        )
    }
}
