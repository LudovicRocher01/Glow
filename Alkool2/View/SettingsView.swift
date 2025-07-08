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
    @State private var showThemeAlert = false

    var body: some View {
        GeometryReader { geometry in
            let isSmall = geometry.size.height < 700

            ZStack {
                Color.backgroundColor
                    .ignoresSafeArea()

                VStack(spacing: isSmall ? 10 : 20) {
                    HStack {
                        Button(action: { dismiss() }) {
                            Text("Retour")
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.buttonRed)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                        }
                        Spacer()
                        
                        NavigationLink(destination: InfoSettingsView()) {
                            Image(systemName: "info.circle.fill")
                                .font(.title)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal)

                    Text("Glou")
                        .font(.custom("ChalkboardSE-Bold", size: isSmall ? 28 : 36))
                        .foregroundColor(.white)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white, lineWidth: 3)
                        )

                    Text("Veuillez choisir un ou plusieurs thèmes pour jouer :")
                        .font(.custom("Marker Felt", size: isSmall ? 14 : 18))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 30)

                    LazyVGrid(columns: [GridItem(), GridItem()], spacing: isSmall ? 10 : 15) {
                        ForEach(themes, id: \.0) { theme in
                            ThemeCell(themeName: theme.0, iconName: theme.1, isSelected: selectedThemes.contains(theme.0), isSmall: isSmall)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    toggleSelection(theme.0)
                                }
                        }
                    }
                    .padding(.horizontal)

                    Spacer()

                    Button(action: {
                        if selectedThemes.isEmpty {
                            showThemeAlert = true
                        } else {
                            path.append("numberView")
                        }
                    }) {
                        Text("Suivant")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .background(Color.buttonRed)
                            .cornerRadius(18)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, isSmall ? 10 : 20)
                    .alert("Attention !", isPresented: $showThemeAlert) {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text("Veuillez sélectionner au moins un thème pour jouer.")
                    }

                }
                .padding(.top, isSmall ? 10 : 20)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            loadSelectedThemes()
        }
    }

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
        if let saved = UserDefaults.standard.array(forKey: "selectedThemes") as? [String], !saved.isEmpty {
            selectedThemes = Set(saved)
        } else {
            selectedThemes = Set(themes.map { $0.0 })
            saveSelectedThemes()
        }
    }
}


struct ThemeCell: View {
    let themeName: String
    let iconName: String
    let isSelected: Bool
    var isSmall: Bool = false

    var body: some View {
        VStack(spacing: isSmall ? 4 : 8) {
            Image(systemName: iconName)
                .font(isSmall ? .body : .title)
                .foregroundColor(isSelected ? .green : .white)
            Text(themeName)
                .font(.custom("Marker Felt", size: isSmall ? 14 : 18))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .padding(isSmall ? 8 : 12)
        .frame(maxWidth: .infinity, minHeight: isSmall ? 70 : 90)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.green : Color.white, lineWidth: 2)
        )
    }
}
