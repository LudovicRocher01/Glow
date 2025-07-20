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
        VStack(spacing: 8) {
            Image(player.avatar)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.starWhite, lineWidth: 2))

            Text(player.name)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.starWhite)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: 100)
        }
        .frame(width: 100)
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
    @State private var penaltyText = ""
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

    private var gameMode: GameMode
    
    private var penaltyUnitPlural: String {
        return gameMode == .glou ? "Glous" : ""
    }
    
    init(path: Binding<NavigationPath>, players: [Player], selectedThemes: [String], totalQuestions: Int) {
        self._path = path
        self.players = players
        self.selectedThemes = selectedThemes
        self.totalQuestions = totalQuestions
        
        if let savedModeRawValue = UserDefaults.standard.string(forKey: "selectedGameMode"),
           let mode = GameMode(rawValue: savedModeRawValue) {
            self.gameMode = mode
        } else {
            self.gameMode = .classic
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.deepSpaceBlue, .cosmicPurple]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            VStack(spacing: 15) {
                HStack(spacing: 15) {
                    Button("Quitter") { showQuitAlert = true }
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.starWhite).padding(.horizontal, 16).padding(.vertical, 8)
                        .background(Color.white.opacity(0.1)).clipShape(Capsule())
                    ProgressView(value: Double(min(max(currentQuestionIndex, 0), totalQuestions)), total: Double(totalQuestions))
                        .tint(.neonMagenta).scaleEffect(x: 1, y: 1.5, anchor: .center)
                }.padding(.horizontal)
                
                HStack(spacing: 15) {
                    if let player1 = currentPlayer { PlayerDisplayView(player: player1)
                        if let player2 = secondPlayerForDisplay {
                            Text("&").font(.system(size: 30, weight: .bold, design: .rounded)).foregroundColor(.lavenderMist)
                            PlayerDisplayView(player: player2)
                        }
                    }
                }.frame(height: 110).id(currentPlayer?.id.uuidString ?? "no_player").transition(.opacity.combined(with: .scale))
                
                VStack(spacing: 20) {
                    Label { Text(theme).font(.system(size: 24, weight: .bold, design: .rounded)) } icon: { Image(systemName: themeIcon).font(.system(size: 24)).symbolEffect(.pulse, options: .repeating) }
                        .foregroundColor(.electricCyan)
                    
                    ScrollView {
                        VStack {
                            Spacer(minLength: 0)
                            Text(question)
                                .font(.system(size: 26, weight: .medium, design: .rounded))
                                .foregroundColor(.starWhite)
                                .multilineTextAlignment(.center)
                                .lineSpacing(5)
                                .minimumScaleFactor(0.6)
                                .padding(.horizontal, 10)
                            Spacer(minLength: 0)
                        }
                        .frame(minHeight: 250)
                    }
                    .frame(maxHeight: 250)
                    
                    if gameMode == .glou && !penaltyText.isEmpty {
                        Text(penaltyText)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.neonMagenta).padding(.vertical, 8).padding(.horizontal, 16)
                            .background(Color.neonMagenta.opacity(0.2)).clipShape(Capsule())
                            .transition(.opacity.combined(with: .scale))
                    }
                }
                .padding(.vertical, 30).padding(.horizontal).frame(maxWidth: .infinity).background(GlassCardBackground()).padding(.horizontal, 20)
                
                Spacer()
                
                if showTimer {
                    if remainingTime > 0 { Text("\(remainingTime)").font(.system(size: 60, weight: .bold, design: .monospaced)).foregroundColor(remainingTime <= 10 ? .neonMagenta : .starWhite).shadow(color: remainingTime <= 10 ? .neonMagenta : .clear, radius: 10).contentTransition(.numericText()).animation(.spring(), value: remainingTime) }
                    else { Text("Temps écoulé").font(.system(size: 24, weight: .bold, design: .rounded)).foregroundColor(.neonMagenta) }
                } else if showChronoButton {
                    Button("Lancer Chrono") { startTimer() }.font(.system(size: 18, weight: .bold, design: .rounded)).foregroundColor(.starWhite).padding().background(Color.electricCyan).clipShape(Capsule()).shadow(color: .electricCyan.opacity(0.7), radius: 8)
                }
                
                Spacer()
                
                if isTrueFalseQuestion && !hasAnsweredTrueFalse {
                    HStack(spacing: 20) {
                        actionButton(title: "Vrai", color: .electricCyan, foreground: .deepSpaceBlue) { checkTrueFalseAnswer(userChoiceIsVrai: true) }
                        actionButton(title: "Faux", color: .neonMagenta) { checkTrueFalseAnswer(userChoiceIsVrai: false) }
                    }
                } else {
                    actionButton(title: shouldRevealAnswer ? "Dévoiler" : (currentQuestionIndex >= totalQuestions ? "Terminer la partie" : "Suivant"), color: shouldRevealAnswer ? .electricCyan : .neonMagenta, foreground: shouldRevealAnswer ? .deepSpaceBlue : .starWhite) {
                        if shouldRevealAnswer { question = currentAnswer; shouldRevealAnswer = false }
                        else { nextQuestion() }
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationBarHidden(true)
        .alert("Quitter la partie", isPresented: $showQuitAlert) { Button("Oui", role: .destructive) { path = NavigationPath() }; Button("Non", role: .cancel) {} } message: { Text("Êtes-vous sûr de vouloir quitter la partie ?") }
        .onAppear { generateNewChallenge() }
    }
    private func actionButton(title: String, color: Color, foreground: Color = .starWhite, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title).font(.system(size: 22, weight: .bold, design: .rounded)).foregroundColor(foreground)
                .frame(height: 60).frame(maxWidth: .infinity).background(color)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous)).shadow(color: color.opacity(0.7), radius: 8, x: 0, y: 4)
        }
        .padding(.horizontal, 30).padding(.bottom, 20)
    }
    
    private func checkTrueFalseAnswer(userChoiceIsVrai: Bool) {
        withAnimation {
            guard let player = currentPlayer else { return }
            let isCorrect = (userChoiceIsVrai == correctAnswerIsVrai)
            var resultMessage: String
            
            if isCorrect {
                resultMessage = "Bonne réponse !"
                if gameMode == .glou { resultMessage += " \(player.name), tu distribues 2 \(penaltyUnitPlural)." }
            } else {
                resultMessage = "Mauvaise réponse !"
                if gameMode == .glou { resultMessage += " \(player.name), tu prends 2 \(penaltyUnitPlural)." }
            }
            
            if let justif = justification { resultMessage += "\n\n\(justif)" }
            self.question = resultMessage
            self.hasAnsweredTrueFalse = true
        }
    }
    
    private func getAvailableThemeTypes() -> [Int] {
        var themeList = [Int]()
        
        if selectedThemes.contains("Catégorie") { themeList += [0, 1, 2, 21, 22] }
        if selectedThemes.contains("Autres") { themeList += [12, 13, 14, 15, 29, 30] }
        if selectedThemes.contains("Je n'ai jamais") { themeList += [6, 7, 8] }
        if selectedThemes.contains("Qui pourrait") { themeList += [9, 10, 11] }
        if selectedThemes.contains("Jeux") { themeList += [3, 4, 5, 16, 17, 18] }
        if selectedThemes.contains("Débats") { themeList += [19, 20] }
        if selectedThemes.contains("Culture G") { themeList += [23, 24, 25] }
        if selectedThemes.contains("Vrai ou Faux") { themeList += [26, 27, 28] }
        
        if gameMode == .classic {
            let forbiddenTypes: Set<Int> = [
                12, 13, // oneUnluck
                14, 15, // Unluck
                30      // Malediction
            ]
            themeList = themeList.filter { !forbiddenTypes.contains($0) }
        }
        
        return themeList.isEmpty ? [23, 24, 25, 26, 27, 28] : themeList
    }

    private func generateNewChallenge() {
        withAnimation(.spring()) {
            timer?.invalidate(); showTimer = false; remainingTime = 30; showChronoButton = false
            shouldRevealAnswer = false; currentAnswer = ""; isTrueFalseQuestion = false
            hasAnsweredTrueFalse = false; justification = nil; currentPlayer = nil; secondPlayerForDisplay = nil
        }
        
        guard !selectedThemes.isEmpty else { theme = "Aucun thème"; penaltyText = ""; question = ""; return }
        
        let themeType = getAvailableThemeTypes().randomElement()!
        
        var randomPlayer: Player; repeat { randomPlayer = players.randomElement()! } while players.count > 1 && randomPlayer.id == previousPlayer?.id
        
        withAnimation(.spring()) {
            previousPlayer = randomPlayer
            var secondPlayer: Player? = nil
            var message = ""

            if gameMode == .glou {
                switch themeType {
                case 0...2: penaltyText = "10 Glous max"
                case 3...5, 16, 17, 18: penaltyText = "3 Glous"
                case 12...13, 14...15: penaltyText = "Glous?"
                case 30: penaltyText = "1 Glou par erreur"
                case 23...25, 26...28, 29, 6...8, 9...11, 19...20, 21...22: penaltyText = "2 Glous"
                default: penaltyText = ""
                }
            } else {
                penaltyText = ""
            }

            switch themeType {
            case 0...2:
                self.currentPlayer = randomPlayer; theme = "Catégorie"; themeIcon = "folder.fill"
                message = "Tu as 30 secondes pour citer autant \(GameData.categories.randomElement() ?? "") que possible..."; showChronoButton = true
            case 3...5:
                self.currentPlayer = randomPlayer; theme = "Défi"; themeIcon = "target"; message = "\(GameData.challenges.randomElement()!)"
            case 12...13:
                self.currentPlayer = randomPlayer; theme = "Action"; themeIcon = "figure.run"; message = "\(GameData.OneUnluck.randomElement()!)"
            case 30:
                self.currentPlayer = randomPlayer; theme = "Malédiction"; themeIcon = "bolt.trianglebadge.exclamationmark"; message = "Jusqu'à la fin de la partie : \(GameData.Malediction.randomElement()!)"
            case 23...25:
                self.currentPlayer = randomPlayer; theme = "Culture G"; themeIcon = "book.closed.fill"; let raw = GameData.Culture.randomElement() ?? "?"; let parts = raw.split(separator: "("); message = "\(parts[0].trimmingCharacters(in: .whitespaces))"; if parts.count > 1 { currentAnswer = parts[1].replacingOccurrences(of: ")", with: ""); shouldRevealAnswer = true }
            case 26...28:
                self.currentPlayer = randomPlayer; theme = "Vrai ou Faux"; themeIcon = "checkmark.circle"; let raw = GameData.TrueOrFalse.randomElement() ?? "?"; let parts = raw.split(separator: "(", maxSplits: 1); message = "\(parts[0].trimmingCharacters(in: .whitespaces))"; isTrueFalseQuestion = true; if parts.count > 1 { let answerContent = String(parts[1].dropLast()); let answerParts = answerContent.split(separator: ",", maxSplits: 1); self.correctAnswerIsVrai = (String(answerParts[0]).trimmingCharacters(in: .whitespaces).lowercased() == "vrai"); if answerParts.count > 1 { self.justification = String(answerParts[1]).trimmingCharacters(in: .whitespaces) } }
            case 16, 29:
                if players.count < 2 { generateNewChallenge(); return }
                secondPlayer = players.filter { $0.id != randomPlayer.id }.randomElement()
                if let sp = secondPlayer { self.currentPlayer = randomPlayer; self.secondPlayerForDisplay = sp; if themeType == 16 { theme = "Versus"; themeIcon = "flag.checkered"; message = "\(GameData.Versus.randomElement()!)" } else { theme = "Confidences"; themeIcon = "lock.shield"; message = "\(randomPlayer.name), concernant \(sp.name) : \(GameData.Confidence.randomElement()!)" } }
            case 6...8:
                theme = "Je n'ai jamais"; themeIcon = "hand.raised.fill"; message = GameData.NeverHave.randomElement()!
            case 9...11:
                theme = "Qui pourrait"; themeIcon = "person.crop.circle.badge.questionmark"; message = "\(GameData.Who.randomElement()!) ?"
            case 14...15:
                theme = "Action Groupe"; themeIcon = "person.3.fill"; message = GameData.Unluck.randomElement()!
            case 17...18:
                self.currentPlayer = randomPlayer; theme = "Jeu"; themeIcon = "gamecontroller.fill"; message = "\(GameData.Game.randomElement()!). \(randomPlayer.name), à toi l'honneur !"
            case 19...20:
                theme = "Débat"; themeIcon = "quote.bubble.fill"; message = GameData.Debate.randomElement()!
            case 21...22:
                self.currentPlayer = randomPlayer; theme = "Catégorie"; themeIcon = "list.bullet.rectangle"; message = "Chacun son tour, citez \(GameData.RoundCategories.randomElement()!). Celui qui se trompe ou hésite trop perd. \(randomPlayer.name), tu commences !"
            default:
                theme = "Erreur"; themeIcon = "xmark.octagon.fill"; message = "Une erreur est survenue."
            }
            if message.isEmpty { generateNewChallenge() } else { question = message }
        }
    }

    private func nextQuestion() {
        if currentQuestionIndex < totalQuestions { currentQuestionIndex += 1; generateNewChallenge() }
        else { path.append("endGame") }
    }

    private func startTimer() {
        showTimer = true; remainingTime = 30; timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.remainingTime > 0 { self.remainingTime -= 1 }
            else { self.timer?.invalidate() }
        }
    }
}
