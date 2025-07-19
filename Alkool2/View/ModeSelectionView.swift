//
//  ModeSelectionView.swift
//  Alkool2
//
//  Created by Ludovic Rocher on 19/07/2025.
//

import SwiftUI

struct ModeSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var path: NavigationPath
    
    @State private var selectedMode: GameMode = .classic

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.deepSpaceBlue, .cosmicPurple]),
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()
            
            VStack(spacing: 30) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Label("Retour", systemImage: "chevron.left")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.starWhite)
                            .padding(.horizontal, 16).padding(.vertical, 10)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Capsule())
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                Spacer().frame(height: 0)
                
                Text("Glou")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.starWhite)
                    .shadow(color: .neonMagenta.opacity(0.8), radius: 10)
                    .padding(.bottom, 12)
                
                Text("Comment voulez-vous jouer ?")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.starWhite)
                
                VStack(spacing: 20) {
                    ModeButton(
                        title: "Mode Classique",
                        subtitle: "Pour une partie fun, sans conséquences",
                        icon: "party.popper.fill", // Icône festive et neutre
                        isSelected: selectedMode == .classic
                    ) {
                        selectedMode = .classic
                    }
                    
                    ModeButton(
                        title: "Mode Glou (17+)",
                        subtitle: "Contenu original avec boissons",
                        icon: "wineglass.fill", // Icône de verre de vin
                        isSelected: selectedMode == .glou
                    ) {
                        selectedMode = .glou
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                Button(action: {
                    saveModeAndContinue()
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
                .padding(.bottom, 20)
            }
            .padding(.top)
        }
        .navigationBarHidden(true)
    }
    
    private func saveModeAndContinue() {
        UserDefaults.standard.set(selectedMode.rawValue, forKey: "selectedGameMode")
        path.append("settings")
    }
}

struct ModeButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                action()
            }
        }) {
            HStack(spacing: 20) {
                Image(systemName: icon)
                    .font(.largeTitle)
                    .foregroundColor(.electricCyan)
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                    Text(subtitle)
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(.lavenderMist)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                }
                .foregroundColor(.starWhite)
                
                Spacer()
            }
            .padding(20)
            .background(
                ZStack {
                    GlassCardBackground()
                    if isSelected {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color.electricCyan, lineWidth: 3)
                            .shadow(color: .electricCyan, radius: 5)
                    }
                }
            )
        }
    }
}
