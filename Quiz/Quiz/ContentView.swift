//
//  ContentView.swift
//  Quiz
//
//  Created by Miguel Mendoza on 27/09/24.
//

import SwiftUI
struct ContentView: View {
    @StateObject private var modelData = ModelData()
    @State private var selectedAnswers: [String?] = []
    @State private var index = 0
    
    var body: some View {
        VStack {
            Text("Quiz")
                .font(.largeTitle)
                .padding(.top, 30)
                .padding(.bottom, 10)
            
            
            if !modelData.questions.isEmpty {
                QuestionView(
                    question: modelData.questions[index],
                    selected: Binding(
                        get: { selectedAnswers[index] },
                        set: { selectedAnswers[index] = $0 }
                    )
                )
            } else {
                ProgressView("Loading questions...")
            }
            
            Spacer()
            navigationButtons
        }
        .padding(.bottom, 30)
        .task {
            await modelData.fetchQuestions()
            selectedAnswers = Array(repeating: nil, count: modelData.questions.count)
        }
    }
    
    private var navigationButtons: some View {
        HStack {
            Button(action: {
                index -= 1
            }, label: {
                Text("Previous")
                    .frame(width: 100, height: 40)
                    .bold()
            })
            .disabled(index == 0)
            .buttonStyle(.borderedProminent)
            .tint(.gray)
        
            
            
            Spacer()
            
            Button(action: {
                index += 1
            }, label: {
                Text("Next")
                    .frame(width: 100, height: 40)
                    .bold()
            })
            .disabled(index + 1 == modelData.questions.count)
            .buttonStyle(.borderedProminent)
            .tint(.blue)
        }
        .padding(.horizontal, 30)
    }
    
    
    
}

#Preview {
    ContentView()
}


