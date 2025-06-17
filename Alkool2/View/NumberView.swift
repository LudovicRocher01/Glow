//
//  NumberView.swift
//  Alkool2
//
//  Created by Ludovic Rocher on 17/06/2025.
//

import SwiftUI

struct NumberView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var path: NavigationPath
    
    var players: [Player]
    var selectedThemes: [String]
    
    @State private var questionCount: Double = Double(UserDefaults.standard.integer(forKey: "savedQuestionCount") > 0 ? UserDefaults.standard.integer(forKey: "savedQuestionCount") : 25)
    
    var body: some View {
        ZStack {
            Color(red: 7/255, green: 5/255, blue: 77/255)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Bouton Retour en haut à gauche
                HStack {
                    Button(action: { dismiss() }) {
                        Text("Retour")
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.red)
                            .cornerRadius(12)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
                
                Spacer().frame(height: 10)
                
                // Titre Alkool centré
                Text("Alkool")
                    .font(.custom("ChalkboardSE-Bold", size: 34))
                    .foregroundColor(.white)
                    .padding(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white, lineWidth: 2)
                    )
                Text("Nombre de thèmes sélectionnés : \(selectedThemes.count)")
                    .foregroundColor(.white)

                
                Spacer().frame(height: 20)
                
                // Texte d'instruction
                Text("Veuillez choisir un nombre\nde questions")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                
                // Slider avec arrondi par 5
                Slider(value: Binding(
                    get: { questionCount },
                    set: { newValue in
                        questionCount = Double(Int(newValue / 5.0) * 5)
                        saveQuestionCount()
                    }
                ), in: 5...50, step: 5)
                .accentColor(.red)
                .padding(.horizontal, 40)
                
                // Affichage du nombre sélectionné
                Text("Nombre de questions : \(Int(questionCount))")
                    .foregroundColor(.white)
                    .padding(.top, 5)
                
                Spacer()
                
                // Bouton Jouer
                Button(action: {
                    path.append("gameView")
                }) {
                    HStack {
                        Text("Jouer")
                            .font(.title2)
                        Image(systemName: "play.fill")
                            .font(.title2)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .navigationBarHidden(true)
    }
    
    // Sauvegarde automatique dans UserDefaults
    private func saveQuestionCount() {
        UserDefaults.standard.set(Int(questionCount), forKey: "savedQuestionCount")
    }
}
