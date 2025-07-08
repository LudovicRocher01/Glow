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
            Color.backgroundColor
                .ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                Text("Fin de la partie !")
                    .font(.custom("Marker Felt", size: 42))
                    .foregroundColor(.white)

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
                        
                        path.removeLast(2)
                        path.append("gameView")
                    }) {
                        Text("Rejouer")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(18)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                    }

                    Button(action: {
                        path = NavigationPath()
                    }) {
                        Text("Retourner au menu")
                            .font(.system(size: 22, weight: .bold))
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
