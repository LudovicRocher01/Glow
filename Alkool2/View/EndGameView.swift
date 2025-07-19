//
//  EndGameView.swift
//  Alkool2
//
//  Created by Ludovic Rocher on 18/06/2025.
//

import SwiftUI

struct EndGameView: View {
    @Binding var path: NavigationPath
    let onReplay: () -> Void
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.deepSpaceBlue, .cosmicPurple]),
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                Text("Fin de la partie !")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundColor(.starWhite)
                    .shadow(color: .neonMagenta.opacity(0.8), radius: 10)

                Image(systemName: "party.popper.fill")
                    .font(.system(size: 100))
                    .foregroundStyle(.yellow, .pink, .cyan)
                    .symbolEffect(.variableColor.iterative.reversing, options: .speed(0.5))
                    .scaleEffect(isAnimating ? 1.0 : 0.5)
                    .opacity(isAnimating ? 1.0 : 0.0)
                
                Spacer()
                
                VStack(spacing: 20) {
                    Button(action: {
                        onReplay()
                        
                        if path.count >= 2 {
                            path.removeLast(2)
                        }
                        path.append("gameView")
                    }) {
                        Label("Rejouer", systemImage: "arrow.counterclockwise")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.deepSpaceBlue)
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .background(Color.electricCyan)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .shadow(color: .electricCyan.opacity(0.7), radius: 8, x: 0, y: 4)
                    }

                    Button(action: {
                        path = NavigationPath()
                    }) {
                        Text("Retourner au menu")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.starWhite)
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .background(Color.neonMagenta)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .shadow(color: .neonMagenta.opacity(0.7), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer().frame(height: 40)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0)) {
                isAnimating = true
            }
        }
    }
}
