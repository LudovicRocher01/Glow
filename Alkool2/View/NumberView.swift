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
            Color.backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Button(action: { dismiss() }) {
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
                .padding(.horizontal)
                .padding(.top)
                
                Spacer().frame(height: 10)
                
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
        
                Spacer().frame(height: 20)
                
                Text("Veuillez choisir un nombre\nde questions")
                    .font(.custom("Marker Felt", size: 18))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Slider(value: Binding(
                    get: { questionCount },
                    set: { newValue in
                        questionCount = Double(Int(newValue / 5.0) * 5)
                        saveQuestionCount()
                    }
                ), in: 5...50, step: 5)
                .accentColor(.red)
                .padding(.horizontal, 40)
                
                Text("Nombre de questions : \(Int(questionCount))")
                    .font(.custom("Marker Felt", size: 18))
                    .foregroundColor(.white)
                    .padding(.top, 5)
                
                Spacer()
                
                Button(action: {
                    path.append("gameView")
                }) {
                    HStack {
                        Text("Jouer")
                            .font(.system(size: 26, weight: .bold))
                        Image(systemName: "play.fill")
                            .font(.system(size: 26, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.buttonRed)
                    .cornerRadius(18)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.white, lineWidth: 2)
                    )
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 20)

            }
        }
        .navigationBarHidden(true)
    }
    
    private func saveQuestionCount() {
        UserDefaults.standard.set(Int(questionCount), forKey: "savedQuestionCount")
    }
}
