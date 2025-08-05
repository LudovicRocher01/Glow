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
        ("Confidences", "lock.shield")
    ]

    @State private var selectedThemes: Set<String> = Set(UserDefaults.standard.array(forKey: "selectedThemes") as? [String] ?? [])
    @State private var showThemeAlert = false

    var body: some View {
        GeometryReader { geometry in
            let isSmallScreen = geometry.size.height < 700

            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.deepSpaceBlue, .cosmicPurple]),
                    startPoint: .top,
                    endPoint: .bottom
                ).ignoresSafeArea()

                VStack(spacing: isSmallScreen ? 15 : 20) {
                    HStack {
                        Button(action: { dismiss() }) {
                            Label("Retour", systemImage: "chevron.left")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.starWhite)
                                .padding(.horizontal, 16).padding(.vertical, 10)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Capsule())
                        }
                        Spacer()
                        
                        NavigationLink(destination: InfoSettingsView()) {
                            Image(systemName: "info.circle.fill")
                                .font(.title)
                                .foregroundColor(.starWhite.opacity(0.8))
                        }
                    }
                    .padding(.horizontal)

                    Text("Glow")
                        .font(.system(size: isSmallScreen ? 36 : 40, weight: .bold, design: .rounded))
                        .foregroundColor(.starWhite)
                        .shadow(color: .neonMagenta.opacity(0.8), radius: 10)
                        .padding(.bottom, 5)

                    Text("Choisissez vos thèmes")
                        .font(.system(size: isSmallScreen ? 20 : 22, weight: .bold, design: .rounded))
                        .foregroundColor(.starWhite)
                        .padding(.horizontal, 30)

                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))], spacing: isSmallScreen ? 15 : 20) {
                            ForEach(themes, id: \.0) { theme in
                                ThemeCell(themeName: theme.0, iconName: theme.1, isSelected: selectedThemes.contains(theme.0), isSmall: isSmallScreen)
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                            toggleSelection(theme.0)
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }

                    Button(action: {
                        if selectedThemes.isEmpty {
                            showThemeAlert = true
                        } else {
                            saveSelectedThemes()
                            path.append("numberView")
                        }
                    }) {
                        Text("Suivant")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.starWhite)
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .background(Color.neonMagenta)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .shadow(color: .neonMagenta, radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, isSmallScreen ? 10 : 20)
                    .alert("Attention !", isPresented: $showThemeAlert) {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text("Veuillez sélectionner au moins un thème pour jouer.")
                    }

                }
                .padding(.top, isSmallScreen ? 10 : 20)
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
        VStack(spacing: isSmall ? 6 : 8) {
            Image(systemName: iconName)
                .font(.system(size: isSelected ? (isSmall ? 30 : 36) : (isSmall ? 26 : 30)))
                .foregroundColor(isSelected ? .electricCyan : .starWhite)
                .symbolEffect(.bounce, value: isSelected)
            
            Text(themeName)
                .font(.system(size: isSmall ? 15 : 16, weight: .semibold, design: .rounded))
                .foregroundColor(.starWhite)
                .multilineTextAlignment(.center)
        }
        .padding(isSmall ? 10 : 12)
        .frame(minHeight: isSmall ? 85 : 90)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                GlassCardBackground()
                if isSelected {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.electricCyan, lineWidth: 3)
                        .shadow(color: .electricCyan, radius: 5, x: 0, y: 0)
                }
            }
        )
    }
}
