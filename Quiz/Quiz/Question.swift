//
//  Question.swift
//  Quiz
//
//  Created by Miguel Mendoza on 27/09/24.
//

import SwiftUI

struct Question: View {
    var question : QuestionModel
    var body: some View {
        Text(question.question)
            .font(Font.title2)
            .bold(true)
    }
}

#Preview {
    Question(question: ModelData.sampleQuestion)
}
