import SwiftUI

struct QuestionView: View {
    var question: QuestionModel
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    @Binding var selected: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(question.question)
                .font(.title2)
                .frame(maxWidth: .infinity, minHeight: 130)
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(question.options, id: \.self) { option in
                    AnswerView(option: option, isCorrect: option == question.correctAnswer, selected: $selected)
                }
            }
        }
        .padding()
    }
}

struct AnswerView: View {
    var option: String
    var isCorrect: Bool
    @Binding var selected: String?
    
    var body: some View {
        Text(option)
            .padding()
            .frame(maxWidth: .infinity, minHeight: 180)
            .background(backgroundColor)
            .cornerRadius(10)
            .onTapGesture {
                if selected == nil {
                    selected = option
                }
            }
    }
    
    private var backgroundColor: Color {
        guard let selected = selected else { return Color.blue.opacity(0.1) }
        if selected == option {
            return isCorrect ? Color.green.opacity(0.3) : Color.red.opacity(0.3)
        } else if isCorrect {
            return Color.green.opacity(0.3)
        }
        return Color.blue.opacity(0.1)
    }
}


#Preview {
    QuestionView(question: ModelData.sampleQuestion, selected: .constant(nil))
}
