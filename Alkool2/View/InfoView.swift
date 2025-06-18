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
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                        }
                        Spacer()
                    }

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
                        
                }
                .padding(.horizontal)
                .padding(.top)

                VStack(alignment: .leading, spacing: 14) {
                    Text("Bienvenue dans Alkool, le jeu festif qui pimente tes soirées entre amis 🍻")
                        .font(.custom("Marker Felt", size: 18))
                        .foregroundColor(.white)

                    Text("Règles du jeu :")
                        .font(.custom("Marker Felt", size: 18))
                        .foregroundColor(.white)
                        .bold()

                    Label("Le nombre de verres affiché indique le nombre de gorgées en jeu.", systemImage: "wineglass")
                        .font(.custom("Marker Felt", size: 18))
                        .foregroundColor(.white)

                    Label("Un joueur peut cumuler deux malédictions. En cas de nouvelle malédiction, il doit en conserver deux maximum. Les autres joueurs choisissent lesquelles.", systemImage: "person.fill.questionmark")
                        .font(.custom("Marker Felt", size: 18))
                        .foregroundColor(.white)

                    Label("Ce jeu est prévu pour un usage festif et responsable. Chacun est libre de ses choix, aucune action ne doit être forcée.", systemImage: "checkmark.seal.fill")
                        .font(.custom("Marker Felt", size: 18))
                        .foregroundColor(.white)

                    Label("Buvez avec modération. L'application n'encourage pas la consommation excessive d'alcool.", systemImage: "scalemass")
                        .font(.custom("Marker Felt", size: 18))
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
