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
            Color.backgroundColor
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
                                .background(Color.buttonRed)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                        }
                        Spacer()
                    }

                    Text("Glou")
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
                    Text("Bienvenue dans Glou, le jeu festif qui anime vos soirées entre amis !")
                        .font(.custom("Marker Felt", size: 18))
                        .foregroundColor(.white)

                    Text("Règles du jeu :")
                        .font(.custom("Marker Felt", size: 18))
                        .foregroundColor(.white)
                        .bold()

                    Label("Chaque carte indique une action, un défi ou une consigne à suivre. À vous de jouer !", systemImage: "gamecontroller.fill")
                        .font(.custom("Marker Felt", size: 18))
                        .foregroundColor(.white)

                    Label("Un joueur peut cumuler deux malédictions. En cas de nouvelle, les autres joueurs choisissent lesquelles conserver.", systemImage: "person.fill.questionmark")
                        .font(.custom("Marker Felt", size: 18))
                        .foregroundColor(.white)

                    Label("Ce jeu est conçu pour un usage amusant, convivial et respectueux. Chacun reste libre de participer à sa façon.", systemImage: "hand.raised.fill")
                        .font(.custom("Marker Felt", size: 18))
                        .foregroundColor(.white)

                    Label("L’application n’encourage aucun comportement à risque. Restez à l’écoute de vos limites et de celles des autres.", systemImage: "exclamationmark.triangle.fill")
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
