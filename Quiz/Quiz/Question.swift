//
//  Question.swift
//  Quiz
//
//  Created by Miguel Mendoza on 27/09/24.
//

import SwiftUI

struct Question: View {
    var question: QuestionModel
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(question.question)
                .font(.title2)
                .fontWeight(.bold)
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(question.options, id: \.self) { option in
                    Answer(option: option)
                }
            }
        }
        .padding()
    }
}

struct Answer: View {
    var option: String
    
    var body: some View {
        Text(option)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
    }
}

#Preview {
    Question(question: ModelData.sampleQuestion)
}
