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
            Color(red: 7/255, green: 5/255, blue: 77/255)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // Haut : bouton retour + titre
                VStack(spacing: 12) {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Retour")
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.red)
                                .cornerRadius(12)
                        }
                        Spacer()
                    }

                    Text("Alkool")
                        .font(.custom("ChalkboardSE-Bold", size: 34))
                        .foregroundColor(.white)
                        .padding(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white, lineWidth: 2)
                        )
                }
                .padding(.horizontal)
                .padding(.top)

                // Corps du texte (ajusté pour ne pas dépasser l’écran)
                VStack(alignment: .leading, spacing: 14) {
                    Text("Bienvenue dans Alkool, le jeu festif qui pimente tes soirées entre amis 🍻")
                        .foregroundColor(.white)

                    Text("Règles du jeu :")
                        .foregroundColor(.white)
                        .bold()

                    Label("Le nombre de verres affiché indique le nombre de gorgées en jeu.", systemImage: "wineglass")
                        .foregroundColor(.white)

                    Label("Un joueur peut cumuler deux malédictions. En cas de nouvelle malédiction, il doit en conserver deux maximum. Les autres joueurs choisissent lesquelles.", systemImage: "person.fill.questionmark")
                        .foregroundColor(.white)

                    Label("Ce jeu est prévu pour un usage festif et responsable. Chacun est libre de ses choix, aucune action ne doit être forcée.", systemImage: "checkmark.seal.fill")
                        .foregroundColor(.white)

                    Label("Buvez avec modération. L'application n'encourage pas la consommation excessive d'alcool.", systemImage: "scalemass")
                        .foregroundColor(.white)
                }
                .font(.callout)
                .padding(.horizontal, 30)

                Spacer()

                Text("v 1.0.0")
                    .foregroundColor(.white.opacity(0.6))
                    .font(.footnote)
                    .padding(.bottom, 10)
            }
        }
        .navigationBarHidden(true)
    }
}
