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
    @State private var themeIcon = "questionmark"
    @State private var sip = "Sip"
    @State private var question = "Question ici"
    @State private var showQuitAlert = false
    @State private var showTimer = false
    @State private var remainingTime = 30
    @State private var timer: Timer?
    @State private var showChronoButton = false
    @State private var currentAnswer: String = ""
    @State private var shouldRevealAnswer: Bool = false
    @State private var previousPlayer: Player? = nil
    
    var body: some View {
        ZStack {
            Color.backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Button("Quitter") {
                        showQuitAlert = true
                    }
                    .alert("Quitter la partie", isPresented: $showQuitAlert) {
                        Button("Oui", role: .destructive) {
                            path = NavigationPath()
                        }
                        Button("Non", role: .cancel) { }
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.buttonRed)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white, lineWidth: 1)
                    )
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
                
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

                Label {
                    Text(theme)
                        .font(.custom("Marker Felt", size: 30))
                        .bold()
                } icon: {
                    Image(systemName: themeIcon)
                        .font(.system(size: 30))
                }
                .foregroundColor(.white)

                
                Text(sip)
                    .font(.custom("Marker Felt", size: 30))
                    .foregroundColor(.white)

                Spacer()

                ScrollView {
                    Text(question)
                        .font(.custom("Marker Felt", size: 24))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                }
                .frame(maxHeight: 200)


                Spacer()

                if showTimer {
                    if remainingTime > 0 {
                        Text("\(remainingTime)")
                            .font(.system(size: remainingTime <= 5 ? 50 : 40, weight: .bold))
                            .scaleEffect(remainingTime <= 5 ? 1.2 : 1.0)
                            .foregroundColor(remainingTime <= 5 ? .red : .white)
                            .padding()
                            .animation(.easeInOut(duration: 0.3), value: remainingTime)
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 2)
                                    .frame(width: 80, height: 80)
                            )
                    } else {
                        Text("Temps écoulé")
                            .font(.title2)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                else if showChronoButton {
                    Button("Chrono") {
                        startTimer()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.buttonRed)
                    .cornerRadius(12)
                }


                ProgressView(
                    value: Double(min(max(currentQuestionIndex, 0), totalQuestions)),
                    total: Double(totalQuestions)
                )
                .accentColor(.red)
                .padding(.horizontal, 40)


                Button(action: {
                    if shouldRevealAnswer {
                        question = currentAnswer
                        shouldRevealAnswer = false
                    } else {
                        nextQuestion()
                    }
                }) {
                    Text(shouldRevealAnswer ? "Dévoiler" : (currentQuestionIndex == totalQuestions ? "Terminer la partie" : "Prochaine question"))
                        .font(.system(size: 26, weight: .bold))
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
        .alert("Quitter la partie", isPresented: $showQuitAlert) {
            Button("Oui", role: .destructive) {
                path = NavigationPath()
            }
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

    private func generateNewChallenge() {
        timer?.invalidate()
        showTimer = false
        remainingTime = 30
        showChronoButton = false
        shouldRevealAnswer = false
        currentAnswer = ""


        guard !selectedThemes.isEmpty else {
            theme = "Aucun thème sélectionné"
            sip = ""
            question = ""
            return
        }

        let themeType = getAvailableThemeTypes().randomElement()!

        var randomPlayer: Player
        repeat {
            randomPlayer = players.randomElement()!
        } while players.count > 1 && randomPlayer.name == previousPlayer?.name
        previousPlayer = randomPlayer

        var secondPlayer: Player? = nil
        var message = ""

        switch themeType {
        case 0...2:
            let category = GameData.categories.randomElement() ?? "une catégorie"
            theme = "Catégorie"
            themeIcon = "folder.fill"
            sip = "10 Glous max"
            message = "\(randomPlayer.name), tu as 30 secondes pour citer autant \(category) que possible. Chaque bonne réponse te permet de distribuer un Glou. Si tu te trompes, c'est toi qui prends."
            showChronoButton = true

        case 3...5:
            let challenge = GameData.challenges.randomElement() ?? ""
            theme = "Défi"
            themeIcon = "target"
            sip = "3 Glous"
            message = "\(randomPlayer.name), \(challenge)"

        case 6...8:
            let never = GameData.NeverHave.randomElement() ?? ""
            theme = "Je n'ai jamais"
            themeIcon = "hand.raised.fill"
            sip = "2 Glous"
            message = never

        case 9...11:
            let who = GameData.Who.randomElement() ?? ""
            theme = "Qui pourrait"
            themeIcon = "person.crop.circle.badge.questionmark"
            sip = "2 Glous"
            message = "\(who) ?"

        case 12...13:
            let action = GameData.OneUnluck.randomElement() ?? ""
            theme = "Action"
            themeIcon = "figure.run"
            sip = "Glous?"
            message = "\(randomPlayer.name), \(action)"

        case 14...15:
            let group = GameData.Unluck.randomElement() ?? ""
            theme = "Action Groupe"
            themeIcon = "person.3.fill"
            sip = "Glous?"
            message = group

        case 16:
            secondPlayer = players.filter { $0.id != randomPlayer.id }.randomElement()
            let versus = GameData.Versus.randomElement() ?? ""
            theme = "Versus"
            themeIcon = "flag.checkered"
            sip = "3 Glous"
            if let sp = secondPlayer {
                message = "\(randomPlayer.name) et \(sp.name), \(versus)"
            }

        case 17:
            let game = GameData.Game.randomElement() ?? ""
            theme = "Jeu"
            themeIcon = "gamecontroller.fill"
            sip = "3 Glous"
            message = "\(game). \(randomPlayer.name), à toi l'honneur !"

        case 18:
            let curse = GameData.Malediction.randomElement() ?? ""
            theme = "Malédiction"
            themeIcon = "bolt.trianglebadge.exclamationmark"
            sip = "1 Glou par erreur"
            message = "\(randomPlayer.name), jusqu'à la fin de la partie : \(curse)"

        case 19...20:
            let debate = GameData.Debate.randomElement() ?? ""
            theme = "Débat"
            themeIcon = "quote.bubble.fill"
            sip = "2 Glous"
            message = debate

        case 21...22:
            let round = GameData.RoundCategories.randomElement() ?? "une catégorie"
            theme = "Catégorie"
            themeIcon = "list.bullet.rectangle"
            sip = "2 Glous"
            message = "Chacun son tour, citez \(round). Celui qui se trompe ou hésite trop perd. \(randomPlayer.name), tu commences !"

        case 23...25:
            let raw = GameData.Culture.randomElement() ?? ""
            let parts = raw.split(separator: "(")
            theme = "Culture G"
            themeIcon = "book.closed.fill"
            sip = "2 Glous"
            message = "\(randomPlayer.name), \(parts[0].trimmingCharacters(in: .whitespaces))"
            if parts.count > 1 {
                currentAnswer = parts[1].replacingOccurrences(of: ")", with: "")
                shouldRevealAnswer = true
            }

        case 26...28:
            let raw = GameData.TrueOrFalse.randomElement() ?? ""
            let parts = raw.split(separator: "(")
            theme = "Vrai ou Faux"
            themeIcon = "checkmark.circle"
            sip = "2 Glous"
            message = "\(randomPlayer.name), \(parts[0].trimmingCharacters(in: .whitespaces))"
            if parts.count > 1 {
                currentAnswer = parts[1].replacingOccurrences(of: ")", with: "")
                shouldRevealAnswer = true
            }

        case 29:
            secondPlayer = players.filter { $0.id != randomPlayer.id }.randomElement()
            let confidence = GameData.Confidence.randomElement() ?? ""
            theme = "Confidences"
            themeIcon = "lock.shield"
            sip = "2 Glous"
            if let sp = secondPlayer {
                message = "\(randomPlayer.name), concernant \(sp.name) : \(confidence)"
            }

        default:
            theme = "Erreur"
            themeIcon = "xmark.octagon.fill"
            sip = ""
            message = "Une erreur est survenue."
        }

        question = message
    }


    private func nextQuestion() {
        timer?.invalidate()
        showTimer = false
        remainingTime = 30
        
        if currentQuestionIndex < totalQuestions {
            currentQuestionIndex += 1
            generateNewChallenge()
        } else {
            showQuitAlert = true
        }
    }

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
