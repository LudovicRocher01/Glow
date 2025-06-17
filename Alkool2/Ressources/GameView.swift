//
//  GameView.swift
//  Alkool2
//
//  Created by Ludovic Rocher on 17/06/2025.
//

import SwiftUI

struct GameView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var path: NavigationPath

    var players: [Player]
    var selectedThemes: [String]
    var totalQuestions: Int

    @State private var currentQuestionIndex = 1
    @State private var theme = "Thème"
    @State private var sip = "Sip"
    @State private var question = "Question ici"
    @State private var showQuitAlert = false
    @State private var showTimer = false
    @State private var remainingTime = 30
    @State private var timer: Timer?
    @State private var showChronoButton = false
    @State private var currentAnswer: String = ""
    @State private var shouldRevealAnswer: Bool = false


    
    var body: some View {
        ZStack {
            
            Color(red: 7/255, green: 5/255, blue: 77/255)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Bouton Quitter
                HStack {
                    Button("Quitter") {
                        showQuitAlert = true
                    }
                    .alert("Quitter la partie", isPresented: $showQuitAlert) {
                        Button("Oui", role: .destructive) {
                            path.removeLast(path.count)
                        }
                        Button("Non", role: .cancel) { }
                    }


                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.red)
                    .cornerRadius(12)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Titre Alkool
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

                // Thème
                Text(theme)
                    .foregroundColor(.white)
                    .font(.title2)
                    .bold()
                
                // Nombre de gorgées
                Text(sip)
                    .foregroundColor(.white)
                    .font(.headline)

                Spacer()

                // Question
                Text(question)
                    .foregroundColor(.white)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Spacer()

                // Chrono
                if showTimer {
                    Text("\(remainingTime)")
                        .font(.largeTitle)
                        .foregroundColor(remainingTime <= 5 ? .red : .white)
                        .padding()
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 2)
                                .frame(width: 80, height: 80)
                        )
                } else if showChronoButton {
                    Button("Chrono") {
                        startTimer()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(12)
                }


                // Progression
                ProgressView(value: Double(currentQuestionIndex), total: Double(totalQuestions))
                    .accentColor(.red)
                    .padding(.horizontal, 40)

                // Bouton Prochaine Question
                Button(action: {
                    if shouldRevealAnswer {
                        // Affiche la réponse, puis revient au comportement normal
                        question = currentAnswer
                        shouldRevealAnswer = false
                    } else {
                        nextQuestion()
                    }
                }) {
                    Text(shouldRevealAnswer ? "Dévoiler" : (currentQuestionIndex == totalQuestions ? "Terminer la partie" : "Prochaine question"))
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
        .alert("Quitter la partie", isPresented: $showQuitAlert) {
            Button("Oui", role: .destructive) { dismiss() }
            Button("Non", role: .cancel) { }
        } message: {
            Text("Êtes-vous sûr de vouloir quitter la partie ?")
        }
        .onAppear {
            generateNewChallenge()
        }
    }
    
    private func getAvailableThemeTypes() -> [Int] {
        var themeList = [Int]()

        if selectedThemes.contains("Catégorie") {
            themeList += [0, 1, 2, 21, 22]
        }
        if selectedThemes.contains("Autres") {
            themeList += [12,13,14,15,18,29]
        }
        if selectedThemes.contains("Je n'ai jamais") {
            themeList += [6,7,8]
        }
        if selectedThemes.contains("Qui pourrait") {
            themeList += [9,10,11]
        }
        if selectedThemes.contains("Jeux") {
            themeList += [3,4,5,16,17]
        }
        if selectedThemes.contains("Débats") {
            themeList += [19,20]
        }
        if selectedThemes.contains("Culture G") {
            themeList += [23,24,25]
        }
        if selectedThemes.contains("Vrai ou Faux") {
            themeList += [26,27,28]
        }

        return themeList
    }

    // Logique basique pour les questions
    private func generateNewChallenge() {
        timer?.invalidate()
        showTimer = false
        remainingTime = 30
        showChronoButton = false

        guard !selectedThemes.isEmpty else {
            theme = "Aucun thème sélectionné"
            sip = ""
            question = ""
            return
        }

        // Sélection du thème aléatoire parmi les disponibles
        let themeType = getAvailableThemeTypes().randomElement()!

        switch themeType {
            case 0...2:
                theme = "Catégorie 📂"
                sip = "10 🥃 max"
                question = "Tu as 30 secondes pour citer des éléments de la catégorie choisie."
                showChronoButton = true

            case 3...5:
                theme = "Défi 🎯"
                sip = "🥃🥃🥃"
                question = GameData.challenges.randomElement()!

            case 6...8:
                theme = "Je n'ai jamais 🙈"
                sip = "🥃🥃"
                question = GameData.NeverHave.randomElement()!

            case 9...11:
                theme = "Qui pourrait 🤔"
                sip = "🥃🥃"
                question = GameData.Who.randomElement()!

            case 12...13:
                theme = "Action 🎬"
                sip = "🥃?"
                question = GameData.OneUnluck.randomElement()!

            case 14...15:
                theme = "Action Groupe 🤹"
                sip = "🥃?"
                question = GameData.Unluck.randomElement()!

            case 16:
                theme = "Versus ⚔️"
                sip = "🥃🥃🥃"
                question = GameData.Versus.randomElement()!

            case 17:
                theme = "Jeu 🎲"
                sip = "🥃🥃🥃"
                question = GameData.Game.randomElement()!

            case 18:
                theme = "Malédiction ☠️"
                sip = "🥃 par erreur"
                question = GameData.Malediction.randomElement()!

            case 19...20:
                theme = "Débat 🗣️"
                sip = "🥃🥃"
                question = GameData.Debate.randomElement()!

        case 23...25:
            theme = "Culture G 📚"
            sip = "🥃🥃"
            let raw = GameData.Culture.randomElement() ?? ""
            let parts = raw.split(separator: "(")
            question = parts[0].trimmingCharacters(in: .whitespaces)
            if parts.count > 1 {
                currentAnswer = parts[1].replacingOccurrences(of: ")", with: "")
                shouldRevealAnswer = true
            }

        case 26...28:
            theme = "Vrai ou Faux ✅"
            sip = "🥃🥃"
            let raw = GameData.TrueOrFalse.randomElement() ?? ""
            let parts = raw.split(separator: "(")
            question = parts[0].trimmingCharacters(in: .whitespaces)
            if parts.count > 1 {
                currentAnswer = parts[1].replacingOccurrences(of: ")", with: "")
                shouldRevealAnswer = true
            }


            case 26...28:
                theme = "Vrai ou Faux ✅"
                sip = "🥃🥃"
                question = GameData.TrueOrFalse.randomElement()!

            case 29:
                theme = "Confidences 🕵️"
                sip = "🥃🥃"
                question = GameData.Confidence.randomElement()!

            default:
                theme = "Erreur"
                sip = ""
                question = "Une erreur inattendue est survenue."
        }
    }

    // Gestion des questions suivantes
    private func nextQuestion() {
        timer?.invalidate()
        showTimer = false
        remainingTime = 30
        
        if currentQuestionIndex < totalQuestions {
            currentQuestionIndex += 1
            generateNewChallenge()
        } else {
            showQuitAlert = true // Fin du jeu, demande de retour menu
        }
    }

    // Gestion du chrono
    private func startTimer() {
        showTimer = true
        remainingTime = 30
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                timer?.invalidate()
            }
        }
    }
}
