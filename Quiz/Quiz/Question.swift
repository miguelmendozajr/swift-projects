import SwiftUI

struct Question: View {
    var question: QuestionModel
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @Binding var selectedAnswer: String?
    @State private var isAnswerSelected = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 20) {
                ScrollView {
                    Text(question.question)
                        .font(.title2)
                        .padding(.bottom)
                }
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(question.options, id: \.self) { option in
                        Answer(selected: $selectedAnswer, isAnswerSelected: $isAnswerSelected, option: option, isCorrect: option == question.correctAnswer)
                            .frame(height: min((geometry.size.height - 100) / 2, 180))
                    }
                }
            }
            .padding()
            .onChange(of: selectedAnswer) { _ in
                isAnswerSelected = selectedAnswer != nil
            }
        }
    }
}

struct Answer: View {
    @Binding var selected: String?
    @Binding var isAnswerSelected: Bool

    var option: String
    var isCorrect: Bool
    
    var body: some View {
        Text(option)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundColor)
            .cornerRadius(10)
            .onTapGesture {
                if !isAnswerSelected {
                    selected = option
                }
            }
    }
    
    private var backgroundColor: Color {
        if isAnswerSelected {
            if selected == option {
                return isCorrect ? Color.green.opacity(0.3) : Color.red.opacity(0.3)
            } else if isCorrect {
                return Color.green.opacity(0.3)
            }
        }
        return Color.blue.opacity(0.1)
    }
}

#Preview {
    Question(question: ModelData.sampleQuestion, selectedAnswer: .constant(nil))
}
