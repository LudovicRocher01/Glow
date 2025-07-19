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
        GameLengthPreset(title: "After", subtitle: "80 Questions", questionCount: 80, iconName: "crown.fill")
    ]
    
    @State private var questionCount: Int = 30
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.deepSpaceBlue, .cosmicPurple]),
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()
            
            VStack(spacing: 25) {
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
                
                Text("Glou")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.starWhite)
                    .shadow(color: .neonMagenta.opacity(0.8), radius: 10)
                    .padding(.bottom, 12)
        
                Text("Choisissez la durée de la partie")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.starWhite)
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 15) {
                    ForEach(presets) { preset in
                        Button(action: {
                            withAnimation(.spring()) {
                                questionCount = preset.questionCount
                                saveQuestionCount()
                            }
                        }) {
                            HStack(spacing: 20) {
                                Image(systemName: preset.iconName)
                                    .font(.title2)
                                    .foregroundColor(.electricCyan)
                                    .frame(width: 30)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(preset.title)
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                        .minimumScaleFactor(0.8)
                                        .lineLimit(2)
                                    Text(preset.subtitle)
                                        .font(.system(size: 14, weight: .regular, design: .rounded))
                                        .foregroundColor(.lavenderMist)
                                }
                                .foregroundColor(.starWhite)
                                
                                Spacer()
                            }
                            .padding()
                            .background(
                                ZStack {
                                    GlassCardBackground()
                                    if questionCount == preset.questionCount {
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .stroke(Color.electricCyan, lineWidth: 3)
                                            .shadow(color: .electricCyan, radius: 5)
                                    }
                                }
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
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                        Image(systemName: "play.fill")
                            .font(.system(size: 20, weight: .bold))
                    }
                    .foregroundColor(.starWhite)
                    .frame(height: 60).frame(maxWidth: .infinity)
                    .background(Color.neonMagenta)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .shadow(color: .neonMagenta, radius: 8, x: 0, y: 4)
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
