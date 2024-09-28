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
    @State var index = 0
    
    var body: some View {
        VStack {
            Text("Quiz")
                .padding(.top, 30)
                .padding(.bottom, 10)
                .font(.largeTitle)
    
            if !modelData.questions.isEmpty {
                Question(
                    question: modelData.questions[index],
                    selectedAnswer: Binding(
                        get: { selectedAnswers.indices.contains(index) ? selectedAnswers[index] : nil },
                        set: { selectedAnswers.indices.contains(index) ? selectedAnswers[index] = $0 : selectedAnswers.append($0) }
                    )
                )
            } else {
                ProgressView("Loading questions...")
            }
            
            Spacer()
            
            HStack {
                Button {
                    index -= 1
                } label: {
                    Text("Previous")
                        .frame(width: 90, height: 30)
                        .bold()
                }
                .buttonStyle(.borderedProminent)
                .tint(.gray)
                .disabled(index == 0)
                .opacity(index == 0 ? 0.5 : 1)
                
                Spacer()
                
                Button {
                    index += 1
                } label: {
                    Text("Next")
                        .frame(width: 90, height: 30)
                        .bold()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .opacity(((index + 1) == modelData.questions.count) ? 0.5 : 1)
                .disabled((index + 1) == modelData.questions.count)
            }
            .padding(30)
        }
        .task {
            await modelData.fetchQuestions()
            selectedAnswers = Array(repeating: nil, count: modelData.questions.count)
        }
    }
}

#Preview {
    ContentView()
}


