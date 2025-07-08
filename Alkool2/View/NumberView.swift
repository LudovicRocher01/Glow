//
//  NumberView.swift
//  Alkool2
//
//  Created by Ludovic Rocher on 17/06/2025.
//

import SwiftUI

struct GameLengthPreset: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let questionCount: Int
    let iconName: String
}

struct NumberView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var path: NavigationPath
    
    var players: [Player]
    var selectedThemes: [String]
    
    private let presets: [GameLengthPreset] = [
        GameLengthPreset(title: "Apéro", subtitle: "15 Questions", questionCount: 15, iconName: "sun.min.fill"),
        GameLengthPreset(title: "Soirée", subtitle: "30 Questions", questionCount: 30, iconName: "moon.stars.fill"),
        GameLengthPreset(title: "Marathon", subtitle: "50 Questions", questionCount: 50, iconName: "flame.fill"),
        GameLengthPreset(title: "Jusqu'au bout de la nuit", subtitle: "80 Questions", questionCount: 80, iconName: "crown.fill")
    ]
    
    @State private var questionCount: Int = 30
    
    var body: some View {
        ZStack {
            Color.backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                HStack {
                    Button(action: { dismiss() }) {
                        Text("Retour").foregroundColor(.white).padding(.horizontal, 20).padding(.vertical, 10)
                            .background(Color.buttonRed).cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white, lineWidth: 1))
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                Text("Glou")
                    .font(.custom("ChalkboardSE-Bold", size: 36))
                    .foregroundColor(.white).padding(.vertical, 2).padding(.horizontal, 10)
                    .background(RoundedRectangle(cornerRadius: 16).stroke(Color.white, lineWidth: 3))
                    .padding(.bottom, 12)
        
                Text("Choisissez la durée de la partie :")
                    .font(.custom("Marker Felt", size: 22))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 15) {
                    ForEach(presets) { preset in
                        Button(action: {
                            questionCount = preset.questionCount
                            saveQuestionCount()
                        }) {
                            HStack(spacing: 15) {
                                Image(systemName: preset.iconName)
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(width: 30)
                                
                                VStack(alignment: .leading) {
                                    Text(preset.title)
                                        .font(.custom("Marker Felt", size: 20))
                                    Text(preset.subtitle)
                                        .font(.system(size: 14, weight: .light))
                                }
                                .foregroundColor(.white)
                                
                                Spacer()
                            }
                            .padding()
                            .background(
                                questionCount == preset.questionCount ? Color.buttonRed.opacity(0.6) : Color.black.opacity(0.2)
                            )
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(questionCount == preset.questionCount ? Color.green : Color.white, lineWidth: 2)
                            )
                        }
                    }
                }
                .padding(.horizontal, 40)
                
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
                    .foregroundColor(.white).frame(height: 60).frame(maxWidth: .infinity)
                    .background(Color.buttonRed).cornerRadius(18)
                    .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.white, lineWidth: 2))
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 20)
            }
            .padding(.top)
        }
        .navigationBarHidden(true)
        .onAppear(perform: loadQuestionCount)
    }
    
    private func saveQuestionCount() {
        UserDefaults.standard.set(questionCount, forKey: "savedQuestionCount")
    }
    
    private func loadQuestionCount() {
        let savedCount = UserDefaults.standard.integer(forKey: "savedQuestionCount")
        if presets.contains(where: { $0.questionCount == savedCount }) {
            questionCount = savedCount
        } else {
            questionCount = 30
            saveQuestionCount()
        }
    }
}
