//
//  InfoSettingsView.swift
//  Alkool2
//
//  Created by Ludovic Rocher on 07/07/2025.
//

import SwiftUI

struct InfoSettingsView: View {
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

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {

                        InfoLabel(icon: "folder.fill", text: "**Catégorie :** Chacun votre tour ou en un temps limité, citez des éléments appartenant à une catégorie donnée jusqu'à répétition ou abandon.")
                        
                        InfoLabel(icon: "hand.raised.fill", text: "**Je n'ai jamais :** Le grand classique. Avez-vous déjà fait ces actions ou été dans ces situations ? Si oui, vous perdez.")
                        
                        InfoLabel(icon: "book.fill", text: "**Culture G :** Testez vos connaissances avec des questions de culture générale. Attention aux pièges !")
                        
                        InfoLabel(icon: "checkmark.circle.fill", text: "**Vrai ou Faux :** Une affirmation vous est présentée. À vous de deviner si elle est vraie ou fausse. Attention aux pièges encore !")
                        
                        InfoLabel(icon: "questionmark.circle.fill", text: "**Qui pourrait :** Une situation est décrite. Tous les joueurs désignent la personne la plus susceptible de la faire. Le joueur le plus désigné perd.")
                        
                        InfoLabel(icon: "gamecontroller.fill", text: "**Jeux :** Des mini-jeux, des défis et des duels entre joueurs pour pimenter la partie. Que le meilleur gagne !")
                        
                        InfoLabel(icon: "bubble.left.and.bubble.right.fill", text: "**Débats :** Choisissez votre camp entre deux options. Les joueurs dans l'équipe minoritaire perdent.")
                    
                        InfoLabel(icon: "lock.shield", text: "**Confidences :** Des questions personnelles et légères pour mieux connaître vos amis. Une bonne occasion de révéler de petits secrets !")
                    }
                }
                .padding(.horizontal, 30)
            }
        }
        .navigationBarHidden(true)
    }
}
