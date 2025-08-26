//
//  GameView.swift
//  Alkool2
//
//  Created by Ludovic Rocher on 17/06/2025.
//

import SwiftUI
import AVFoundation

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
    @State private var intensityText = ""
    @State private var question = "Question ici"
    @State private var showQuitAlert = false
    @State private var showTimer = false
    @State private var remainingTime = 30
    @State private var timer: Timer?
    @State private var showChronoButton = false
    @State private var previousPlayer: Player? = nil
    @State private var audioPlayer: AVAudioPlayer?
    
    @State private var currentPlayer: Player? = nil
    @State private var secondPlayerForDisplay: Player? = nil
    
    @State private var isTrueFalseQuestion = false
    @State private var hasAnsweredTrueFalse = false
    @State private var correctAnswerIsVrai = false
    @State private var justification: String? = nil
    
    @State private var currentAnswer: String = ""
    @State private var shouldRevealAnswer: Bool = false
    @State private var gameMode: String = "Normal"
    @State private var previousTheme: String? = nil
        
    init(path: Binding<NavigationPath>, players: [Player], selectedThemes: [String], totalQuestions: Int) {
        self._path = path
        self.players = players
        self.selectedThemes = selectedThemes
        self.totalQuestions = totalQuestions
    }
    
    var body: some View {
        GeometryReader { geometry in
            let isSmallScreen = geometry.size.height < 700
            
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.deepSpaceBlue, .cosmicPurple]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                
                VStack(spacing: isSmallScreen ? 10 : 15) {
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
                    }
                    .frame(height: isSmallScreen ? 90 : 110)
                    .id(currentPlayer?.id.uuidString ?? "no_player").transition(.opacity.combined(with: .scale))
                    
                    VStack(spacing: isSmallScreen ? 15 : 20) {
                        Label { Text(theme).font(.system(size: 24, weight: .bold, design: .rounded)) } icon: { Image(systemName: themeIcon).font(.system(size: 24)).symbolEffect(.pulse, options: .repeating) }
                            .foregroundColor(.electricCyan)
                        
                        ScrollView {
                            VStack {
                                Spacer(minLength: 0)
                                Text(question)
                                    .font(.system(size: isSmallScreen ? 22 : 26, weight: .medium, design: .rounded))
                                    .foregroundColor(.starWhite).multilineTextAlignment(.center).lineSpacing(5)
                                    .minimumScaleFactor(0.6).padding(.horizontal, 10)
                                Spacer(minLength: 0)
                            }
                            .frame(minHeight: isSmallScreen ? 180 : 250)
                        }
                        .frame(maxHeight: isSmallScreen ? 180 : 250)
                        
                        if !intensityText.isEmpty {
                            Text(intensityText)
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.neonMagenta).padding(.vertical, 8).padding(.horizontal, 16)
                                .background(Color.neonMagenta.opacity(0.2)).clipShape(Capsule())
                                .transition(.opacity.combined(with: .scale))
                        }
                    }
                    .padding(.vertical, isSmallScreen ? 20 : 30)
                    .padding(.horizontal).frame(maxWidth: .infinity).background(GlassCardBackground()).padding(.horizontal, 20)
                    
                    Spacer(minLength: 10)
                    
                    if showTimer {
                        if remainingTime > 0 { Text("\(remainingTime)").font(.system(size: 60, weight: .bold, design: .monospaced)).foregroundColor(remainingTime <= 10 ? .neonMagenta : .starWhite).shadow(color: remainingTime <= 10 ? .neonMagenta : .clear, radius: 10).contentTransition(.numericText()).animation(.spring(), value: remainingTime) }
                        else { Text("Temps écoulé").font(.system(size: 24, weight: .bold, design: .rounded)).foregroundColor(.neonMagenta) }
                    } else if showChronoButton {
                        Button("Lancer Chrono") { startTimer() }.font(.system(size: 18, weight: .bold, design: .rounded)).foregroundColor(.starWhite).padding().background(Color.electricCyan).clipShape(Capsule()).shadow(color: .electricCyan.opacity(0.7), radius: 8)
                    }
                    
                    Spacer(minLength: 10)
                    
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
            .alert("Quitter la partie", isPresented: $showQuitAlert) { Button("Oui", role: .destructive) {
                path = NavigationPath()
            };
                Button("Non", role: .cancel) {} } message: { Text("Êtes-vous sûr de vouloir quitter la partie ?") }
            .onAppear {
                generateNewChallenge()
                setupAudioPlayer()
            }
        }
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
            let isCorrect = (userChoiceIsVrai == correctAnswerIsVrai)
            var resultMessage: String
            
            if isCorrect {
                resultMessage = "Bonne réponse !"
            } else {
                resultMessage = "Mauvaise réponse !"
            }
            
            if let justif = justification { resultMessage += "\n\n\(justif)" }
            self.question = resultMessage
            self.hasAnsweredTrueFalse = true
        }
    }
    
    private func getTypes(for theme: String) -> [Int] {
        switch theme {
        case "Catégorie": return [0, 1, 2, 21, 22]
        case "Aléas": return [12, 13, 14, 15, 29, 30]
        case "Je n'ai jamais": return [6, 7, 8]
        case "Qui pourrait": return [9, 10, 11]
        case "Jeux": return [3, 4, 5, 16, 17, 18]
        case "Débats": return [19, 20]
        case "Culture G": return [23, 24, 25]
        case "Vrai ou Faux": return [26, 27, 28]
        default: return []
        }
    }
    
    private func generateNewChallenge() {
        withAnimation(.spring()) {
            timer?.invalidate(); showTimer = false; remainingTime = 30; showChronoButton = false
            shouldRevealAnswer = false; currentAnswer = ""; isTrueFalseQuestion = false
            hasAnsweredTrueFalse = false; justification = nil; currentPlayer = nil; secondPlayerForDisplay = nil
        }
        
        guard !selectedThemes.isEmpty else { theme = "Aucun thème"; intensityText = ""; question = ""; return }
        
        var randomTheme = selectedThemes.randomElement()!
        
        if randomTheme == previousTheme, selectedThemes.count > 1 {
            if Bool.random() {
                print("Répétition de thème évitée, repioche...")
                let otherThemes = selectedThemes.filter { $0 != previousTheme }
                if let newTheme = otherThemes.randomElement() {
                    randomTheme = newTheme
                }
            }
        }
        
        previousTheme = randomTheme
        
        let availableTypes = getTypes(for: randomTheme)
        guard let themeType = availableTypes.randomElement() else {
            generateNewChallenge() // Sécurité si le thème n'a pas de types
            return
        }
        var randomPlayer: Player; repeat { randomPlayer = players.randomElement()! } while players.count > 1 && randomPlayer.id == previousPlayer?.id
        
        withAnimation(.spring()) {
            previousPlayer = randomPlayer
            var secondPlayer: Player? = nil
            var message = ""
            intensityText = ""
            
            self.theme = randomTheme
            self.themeIcon = getIcon(for: randomTheme)
            
            switch themeType {
            case 0...2:
                self.currentPlayer = randomPlayer; theme = "Catégorie"; themeIcon = "folder.fill"
                intensityText = "10 Glow max"
                message = "Tu as 30 secondes pour citer autant \(GameData.categories.randomElement() ?? "") que possible..."; showChronoButton = true
            case 3...5:
                self.currentPlayer = randomPlayer; theme = "Défi"; themeIcon = "target";
                intensityText = "3 Glow en cas d'erreur ou refus"
                message = "\(GameData.challenges.randomElement()!)"
            case 12...13:
                self.currentPlayer = randomPlayer; theme = "Action"; themeIcon = "figure.run";
                intensityText = ""
                message = "\(GameData.OneUnluck.randomElement()!)"
            case 30:
                self.currentPlayer = randomPlayer; theme = "Malédiction"; themeIcon = "bolt.trianglebadge.exclamationmark";
                intensityText = "1 Glow par erreur"
                message = "Jusqu'à la fin de la partie : \(GameData.Malediction.randomElement()!)"
            case 23...25:
                self.currentPlayer = randomPlayer; theme = "Culture G"; themeIcon = "book.closed.fill"; let raw = GameData.Culture.randomElement() ?? "?"; let parts = raw.split(separator: "(");
                intensityText = "2 Glow"
                message = "\(parts[0].trimmingCharacters(in: .whitespaces))"; if parts.count > 1 { currentAnswer = parts[1].replacingOccurrences(of: ")", with: ""); shouldRevealAnswer = true }
            case 26...28:
                self.currentPlayer = randomPlayer; theme = "Vrai ou Faux"; themeIcon = "checkmark.circle"; let raw = GameData.TrueOrFalse.randomElement() ?? "?"; let parts = raw.split(separator: "(", maxSplits: 1);
                intensityText = "2 Glow"
                message = "\(parts[0].trimmingCharacters(in: .whitespaces))"; isTrueFalseQuestion = true; if parts.count > 1 { let answerContent = String(parts[1].dropLast()); let answerParts = answerContent.split(separator: ",", maxSplits: 1); self.correctAnswerIsVrai = (String(answerParts[0]).trimmingCharacters(in: .whitespaces).lowercased() == "vrai"); if answerParts.count > 1 { self.justification = String(answerParts[1]).trimmingCharacters(in: .whitespaces) } }
            case 16, 29:
                intensityText = "2 Glow"
                if players.count < 2 { generateNewChallenge(); return }
                secondPlayer = players.filter { $0.id != randomPlayer.id }.randomElement()
                if let sp = secondPlayer { self.currentPlayer = randomPlayer; self.secondPlayerForDisplay = sp; if themeType == 16 { theme = "Versus"; themeIcon = "flag.checkered";
                    message = "\(GameData.Versus.randomElement()!)" } else { theme = "Confidences"; themeIcon = "lock.shield"; message = "\(randomPlayer.name), concernant \(sp.name) : \(GameData.Confidence.randomElement()!)" } }
            case 6...8:
                theme = "Je n'ai jamais"; themeIcon = "hand.raised.fill";
                intensityText = "1 Glow"
                message = GameData.NeverHave.randomElement()!
            case 9...11:
                theme = "Qui pourrait"; themeIcon = "person.crop.circle.badge.questionmark";
                intensityText = "3 Glow"
                message = "\(GameData.Who.randomElement()!) ?"
            case 14...15:
                theme = "Action Groupe"; themeIcon = "person.3.fill";
                intensityText = ""
                message = GameData.Unluck.randomElement()!
            case 17...18:
                self.currentPlayer = randomPlayer; theme = "Jeu"; themeIcon = "gamecontroller.fill";
                intensityText = "3 Glow"
                message = "\(GameData.Game.randomElement()!)."
            case 19...20:
                theme = "Débat"; themeIcon = "quote.bubble.fill";
                intensityText = "1 Glow"
                message = GameData.Debate.randomElement()!
            case 21...22:
                self.currentPlayer = randomPlayer; theme = "Catégorie"; themeIcon = "list.bullet.rectangle";
                intensityText = "3 Glow"
                message = "Chacun son tour, citez \(GameData.RoundCategories.randomElement()!). Celui qui se trompe ou hésite trop perd. \(randomPlayer.name), tu commences !"
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
    
    private func getIcon(for theme: String) -> String {
        switch theme {
        case "Catégorie": return "folder.fill"
        case "Aléas": return "questionmark.circle.fill"
        case "Je n'ai jamais": return "hand.raised.fill"
        case "Qui pourrait": return "person.crop.circle.badge.questionmark"
        case "Jeux": return "gamecontroller.fill"
        case "Débats": return "bubble.left.and.bubble.right.fill"
        case "Culture G": return "book.fill"
        case "Vrai ou Faux": return "checkmark.circle.fill"
        default: return "questionmark"
        }
    }
    
    private func startTimer() {
        showTimer = true
        remainingTime = 30
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.remainingTime > 1 {
                self.remainingTime -= 1
            } else {
                self.remainingTime = 0
                self.audioPlayer?.play()
                self.timer?.invalidate()
            }
        }
    }
    
    private func setupAudioPlayer() {
        guard let soundURL = Bundle.main.url(forResource: "timer_alarm", withExtension: "mp3") else {
            print("Fichier son non trouvé.")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Erreur lors de l'initialisation de l'audio player: \(error.localizedDescription)")
        }
    }
}
