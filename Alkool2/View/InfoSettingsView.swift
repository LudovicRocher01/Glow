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

                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        
                        Text("Description des thèmes :")
                            .font(.custom("Marker Felt", size: 22))
                            .foregroundColor(.white)
                            .bold()
                            .padding(.bottom, 5)

                        Label {
                            Text("**Catégorie :** Chacun votre tour ou en un temps limité, citez des éléments appartenant à une catégorie donnée jusqu'à répétition ou abandon")
                        } icon: {
                            Image(systemName: "folder.fill")
                        }
                        
                        Label {
                            Text("**Je n'ai jamais :** Le grand classique. Avez-vous déjà fait ces actions ou été dans ces situations ? Si oui, vous perdez.")
                        } icon: {
                            Image(systemName: "hand.raised.fill")
                        }

                        Label {
                            Text("**Culture G :** Testez vos connaissances avec des questions de culture générale. Attention aux pièges !")
                        } icon: {
                            Image(systemName: "book.fill")
                        }

                        Label {
                            Text("**Vrai ou Faux :** Une affirmation vous est présentée. À vous de deviner si elle est vraie ou fausse. Attention aux pièges encore !")
                        } icon: {
                            Image(systemName: "checkmark.circle.fill")
                        }

                        Label {
                            Text("**Qui pourrait :** Une situation est décrite. Tous les joueurs désignent la personne la plus susceptible de la faire. Le joueur le plus désigné perd.")
                        } icon: {
                            Image(systemName: "questionmark.circle.fill")
                        }

                        Label {
                            Text("**Jeux :** Des mini-jeux, des défis et des duels entre joueurs pour pimenter la partie. Que le meilleur gagne !")
                        } icon: {
                            Image(systemName: "gamecontroller.fill")
                        }

                        Label {
                            Text("**Débats :** Choisissez votre camp entre deux options. Les joueurs dans l'équipe minoritaire perdent.")
                        } icon: {
                            Image(systemName: "bubble.left.and.bubble.right.fill")
                        }

                        Label {
                            Text("**Autres :** Un mélange de règles spéciales, de malédictions, de questions personnelles et d'actions de groupe. Attendez-vous à tout !")
                        } icon: {
                            Image(systemName: "sparkles")
                        }
                    }
                    .font(.custom("Marker Felt", size: 18))
                    .foregroundColor(.white)
                }
                .padding(.horizontal, 30)
            }
        }
        .navigationBarHidden(true)
    }
}
