//
//  InfoView.swift
//  Alkool2
//
//  Created by Ludovic Rocher on 17/06/2025.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.deepSpaceBlue, .cosmicPurple]),
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()

            VStack(spacing: 20) {
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
                }
                .padding(.horizontal)
                .padding(.top)

                Text("Glow")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.starWhite)
                    .shadow(color: .neonMagenta.opacity(0.8), radius: 10)
                    .padding(.bottom, 20)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 25) {
                    Text("Bienvenue dans Glow, le jeu qui illumine vos soirées !")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.starWhite)
                        .padding(.bottom, 10)

                    Text("Règles du jeu :")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.electricCyan)

                    InfoLabel(
                        icon: "gamecontroller.fill",
                        text: "Suivez simplement les instructions de chaque carte. Le but est de lancer des conversations, de créer des défis amusants et de partager de bons moments."
                    )
                    
                    InfoLabel(
                        icon: "person.3.fill",
                        text: "Il n'y a ni gagnant, ni perdant ! L'objectif est de s'amuser tous ensemble, dans le respect et la bonne humeur."
                    )
                    
                    InfoLabel(
                        icon: "hand.raised.fill",
                        text: "Soyez créatifs et n'hésitez pas à adapter les règles. Chaque groupe est unique, et votre partie le sera aussi !"
                    )
                }
                .padding(.horizontal, 30)

                Spacer()

                Text("v 1.0.0")
                    .font(.footnote)
                    .foregroundColor(.starWhite.opacity(0.6))
                    .padding(.bottom, 10)
            }
        }
        .navigationBarHidden(true)
    }
}

struct InfoLabel: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.electricCyan)
                .frame(width: 25, alignment: .center)
            
            Text(LocalizedStringKey(text))
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundColor(.starWhite)
                .lineSpacing(4)
        }
    }
}
