//
//  ContentView.swift
//  FocusBuddy
//
//  Created by ivan trajanovski  on 22.06.23.
//

import SwiftUI

struct ContentView: View {
    @State private var timerSeconds = 0
    @State private var timerRunning = false
    @State private var showAlert = false
    @State private var isPaused = false
    
    let focusDuration = 25 * 60 // 25 minutes
    let breakDuration = 5 * 60 // 5 minutes
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text(timeString(from: timerSeconds))
                    .font(.system(size: 80, weight: .thin))
                    .foregroundColor(.white)
                
                HStack(spacing: 20) {
                    Button(action: {
                        startTimer(duration: focusDuration)
                    }) {
                        Text("Start Focus")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        startTimer(duration: breakDuration)
                    }) {
                        Text("Start Break")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(10)
                    }
                }
                
                HStack(spacing: 20) {
                    Button(action: {
                        if isPaused {
                            isPaused = false
                            startTimer(duration: timerSeconds)
                        } else {
                            isPaused = true
                            timerRunning = false
                        }
                    }) {
                        Text(isPaused ? "Continue" : "Pause")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        resetTimer()
                    }) {
                        Text("Reset")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(.red)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Time's Up!"),
                message: Text(timerSeconds == focusDuration ? "Focus session completed." : "Break time is over."),
                dismissButton: .default(Text("OK")) {
                    resetTimer()
                }
            )
        }
    }
    
    private func startTimer(duration: Int) {
        if !timerRunning {
            timerSeconds = duration
            timerRunning = true
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if timerSeconds > 0  && !isPaused {
                    timerSeconds -= 1
                } else if timerSeconds <= 0 {
                    timer.invalidate()
                    showAlert = true
                }
            }
        }
    }
    
    private func resetTimer() {
        timerSeconds = 0
        timerRunning = false
        isPaused = false
    }
    
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

