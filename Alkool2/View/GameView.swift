//
//  GameView.swift
//  Alkool2
//
//  Created by Ludovic Rocher on 17/06/2025.
//

import SwiftUI

struct PlayerDisplayView: View {
    let player: Player
    
    var body: some View {
        VStack {
            Image(player.avatar)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 2))

            Text(player.name)
                .font(.custom("Marker Felt", size: 22))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(width: 80)
    }
}


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
    @State private var previousPlayer: Player? = nil
    
    @State private var currentPlayer: Player? = nil
    @State private var secondPlayerForDisplay: Player? = nil
    
    @State private var isTrueFalseQuestion = false
    @State private var hasAnsweredTrueFalse = false
    @State private var correctAnswerIsVrai = false
    @State private var justification: String? = nil
    
    @State private var currentAnswer: String = ""
    @State private var shouldRevealAnswer: Bool = false


    var body: some View {
        ZStack {
            Color.backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Button("Quitter") { showQuitAlert = true }
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
                
                if let player1 = currentPlayer {
                    HStack(spacing: 15) {
                        PlayerDisplayView(player: player1)
                        
                        if let player2 = secondPlayerForDisplay {
                            Text("et")
                                .font(.custom("Marker Felt", size: 24))
                                .foregroundColor(.white)
                                .padding(.bottom, 25)
                            
                            PlayerDisplayView(player: player2)
                        }
                    }
                    .padding(.bottom, 10)
                    .frame(height: 80)
                } else {
                    Spacer().frame(height: 80)
                }

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
                    .underline()

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
                            .overlay(Circle().stroke(Color.white, lineWidth: 2).frame(width: 80, height: 80))
                    } else {
                        Text("Temps écoulé").font(.title2).foregroundColor(.red).padding()
                    }
                }
                else if showChronoButton {
                    Button("Chrono") { startTimer() }
                    .foregroundColor(.white).padding().background(Color.buttonRed).cornerRadius(12)
                }

                ProgressView(
                    value: Double(min(max(currentQuestionIndex, 0), totalQuestions)),
                    total: Double(totalQuestions)
                )
                .accentColor(.red)
                .padding(.horizontal, 40)

                if isTrueFalseQuestion && !hasAnsweredTrueFalse {
                    HStack(spacing: 20) {
                        Button(action: { checkTrueFalseAnswer(userChoiceIsVrai: true) }) {
                            Text("Vrai")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(.white)
                                .frame(height: 60)
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .cornerRadius(18)
                                .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.white, lineWidth: 2))
                        }
                        
                        Button(action: { checkTrueFalseAnswer(userChoiceIsVrai: false) }) {
                            Text("Faux")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(.white)
                                .frame(height: 60)
                                .frame(maxWidth: .infinity)
                                .background(Color.buttonRed)
                                .cornerRadius(18)
                                .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.white, lineWidth: 2))
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
                } else {
                    Button(action: {
                        if shouldRevealAnswer {
                            question = currentAnswer
                            shouldRevealAnswer = false
                        } else {
                            nextQuestion()
                        }
                    }) {
                        Text(shouldRevealAnswer ? "Dévoiler" : (currentQuestionIndex >= totalQuestions ? "Terminer la partie" : "Prochaine question"))
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .background(Color.buttonRed)
                            .cornerRadius(18)
                            .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.white, lineWidth: 2))
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationBarHidden(true)
        .alert("Quitter la partie", isPresented: $showQuitAlert) {
            Button("Oui", role: .destructive) { path = NavigationPath() }
            Button("Non", role: .cancel) { }
        } message: {
            Text("Êtes-vous sûr de vouloir quitter la partie ?")
        }
        .onAppear {
            generateNewChallenge()
        }
    }
    
    
    private func checkTrueFalseAnswer(userChoiceIsVrai: Bool) {
        guard let player = currentPlayer else { return }

        let isCorrect = (userChoiceIsVrai == correctAnswerIsVrai)
        var resultMessage: String

        if isCorrect {
            resultMessage = "Bonne réponse ! \(player.name), tu distribues 2 Glous."
        } else {
            resultMessage = "Mauvaise réponse ! \(player.name), tu prends 2 Glous."
        }
        
        if let justif = justification {
            resultMessage += "\n\n\(justif)"
        }
        
        self.question = resultMessage
        self.hasAnsweredTrueFalse = true
    }
    
    private func getAvailableThemeTypes() -> [Int] {
        var themeList = [Int]()

        if selectedThemes.contains("Catégorie") { themeList += [0, 1, 2, 21, 22] }
        if selectedThemes.contains("Autres") { themeList += [12,13,14,15,18,29] }
        if selectedThemes.contains("Je n'ai jamais") { themeList += [6,7,8] }
        if selectedThemes.contains("Qui pourrait") { themeList += [9,10,11] }
        if selectedThemes.contains("Jeux") { themeList += [3,4,5,16,17] }
        if selectedThemes.contains("Débats") { themeList += [19,20] }
        if selectedThemes.contains("Culture G") { themeList += [23,24,25] }
        if selectedThemes.contains("Vrai ou Faux") { themeList += [26,27,28] }

        return themeList
    }

    private func generateNewChallenge() {
        timer?.invalidate(); showTimer = false; remainingTime = 30
        showChronoButton = false; shouldRevealAnswer = false; currentAnswer = ""
        isTrueFalseQuestion = false; hasAnsweredTrueFalse = false; justification = nil
        currentPlayer = nil
        secondPlayerForDisplay = nil
        
        guard !selectedThemes.isEmpty else {
            theme = "Aucun thème sélectionné"; sip = ""; question = ""
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
            self.currentPlayer = randomPlayer
            theme = "Catégorie"; themeIcon = "folder.fill"; sip = "10 Glous max"
            message = "Tu as 30 secondes pour citer autant \(GameData.categories.randomElement() ?? "") que possible..."
            showChronoButton = true

        case 3...5:
            self.currentPlayer = randomPlayer
            theme = "Défi"; themeIcon = "target"; sip = "3 Glous"
            message = "\(GameData.challenges.randomElement()!)"

        case 12...13:
            self.currentPlayer = randomPlayer
            theme = "Action"; themeIcon = "figure.run"; sip = "Glous?"
            message = "\(GameData.OneUnluck.randomElement()!)"
            
        case 18:
            self.currentPlayer = randomPlayer
            theme = "Malédiction"; themeIcon = "bolt.trianglebadge.exclamationmark"; sip = "1 Glou par erreur"
            message = "Jusqu'à la fin de la partie : \(GameData.Malediction.randomElement()!)"
            
        case 23...25:
            self.currentPlayer = randomPlayer
            theme = "Culture G"; themeIcon = "book.closed.fill"; sip = "2 Glous"
            let raw = GameData.Culture.randomElement() ?? "?"; let parts = raw.split(separator: "(")
            message = "\(parts[0].trimmingCharacters(in: .whitespaces))"
            if parts.count > 1 { currentAnswer = parts[1].replacingOccurrences(of: ")", with: ""); shouldRevealAnswer = true }

        case 26...28:
            self.currentPlayer = randomPlayer
            theme = "Vrai ou Faux"; themeIcon = "checkmark.circle"; sip = "2 Glous"
            let raw = GameData.TrueOrFalse.randomElement() ?? "?"; let parts = raw.split(separator: "(", maxSplits: 1)
            message = "\(parts[0].trimmingCharacters(in: .whitespaces))"
            isTrueFalseQuestion = true
            if parts.count > 1 {
                let answerContent = String(parts[1].dropLast()); let answerParts = answerContent.split(separator: ",", maxSplits: 1)
                self.correctAnswerIsVrai = (String(answerParts[0]).trimmingCharacters(in: .whitespaces).lowercased() == "vrai")
                if answerParts.count > 1 { self.justification = String(answerParts[1]).trimmingCharacters(in: .whitespaces) }
            }

        case 16:
            secondPlayer = players.filter { $0.id != randomPlayer.id }.randomElement()
            if let sp = secondPlayer {
                self.currentPlayer = randomPlayer
                self.secondPlayerForDisplay = sp
                theme = "Versus"; themeIcon = "flag.checkered"; sip = "3 Glous"
                message = "\(GameData.Versus.randomElement()!)"
            }
            
        case 29:
            secondPlayer = players.filter { $0.id != randomPlayer.id }.randomElement()
            if let sp = secondPlayer {
                self.currentPlayer = randomPlayer
                self.secondPlayerForDisplay = sp
                theme = "Confidences"; themeIcon = "lock.shield"; sip = "2 Glous"
                message = "\(randomPlayer.name), concernant \(sp.name) : \(GameData.Confidence.randomElement()!)"
            }

        case 6...8:
            theme = "Je n'ai jamais"; themeIcon = "hand.raised.fill"; sip = "2 Glous"
            message = GameData.NeverHave.randomElement()!
            
        case 9...11:
            theme = "Qui pourrait"; themeIcon = "person.crop.circle.badge.questionmark"; sip = "2 Glous"
            message = "\(GameData.Who.randomElement()!) ?"
            
        case 14...15:
            theme = "Action Groupe"; themeIcon = "person.3.fill"; sip = "Glous?"
            message = GameData.Unluck.randomElement()!
        
        case 17:
            theme = "Jeu"; themeIcon = "gamecontroller.fill"; sip = "3 Glous"
            message = "\(GameData.Game.randomElement()!), \(randomPlayer.name), à toi l'honneur !"
            
        case 19...20:
            theme = "Débat"; themeIcon = "quote.bubble.fill"; sip = "2 Glous"
            message = GameData.Debate.randomElement()!
            
        case 21...22:
            theme = "Catégorie"; themeIcon = "list.bullet.rectangle"; sip = "2 Glous"
            message = "Chacun son tour, citez \(GameData.RoundCategories.randomElement()!). Celui qui se trompe ou hésite trop perd. \(randomPlayer.name), tu commences !"
            
        default:
            theme = "Erreur"; themeIcon = "xmark.octagon.fill"; sip = ""
            message = "Une erreur est survenue."
        }
        
        if message.isEmpty {
            generateNewChallenge()
        } else {
            question = message
        }
    }

    private func nextQuestion() {
        if currentQuestionIndex < totalQuestions {
            currentQuestionIndex += 1
            generateNewChallenge()
        } else {
            path = NavigationPath()
        }
    }

    private func startTimer() {
        showTimer = true
        remainingTime = 30
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                self.timer?.invalidate()
            }
        }
    }
}
