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

                Text("Glou")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.starWhite)
                    .shadow(color: .neonMagenta.opacity(0.8), radius: 10)
                    .padding(.bottom, 20)
                                
                VStack(alignment: .leading, spacing: 25) {
                    Text("Bienvenue dans Glou, le jeu qui illumine vos soirées !")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.starWhite)
                        .padding(.bottom, 10)

                    Text("Comment jouer ?")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.electricCyan)

                    InfoLabel(
                        icon: "party.popper.fill",
                        text: "**Mode Classique :** Le mode par défaut. Suivez simplement les instructions de chaque carte pour une partie amusante, parfaite pour tous les groupes."
                    )
                    
                    InfoLabel(
                        icon: "wineglass.fill",
                        text: "**Mode Glou (17+) :** Une version alternative où les perdants reçoivent des gages. Ce mode est optionnel et doit être choisi en connaissance de cause."
                    )
                    
                    InfoLabel(
                        icon: "hand.raised.fill",
                        text: "Amusez-vous dans le respect et la bonne humeur. Chacun est toujours libre de participer à sa manière."
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
