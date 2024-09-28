import SwiftUI

struct Question: View {
    var question: QuestionModel
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 20) {
                ScrollView {
                    Text(question.question)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom)
                }
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(question.options, id: \.self) { option in
                        Answer(option: option)
                            .frame(height: min((geometry.size.height - 150) / 2, 200)) // Adjust as needed
                    }
                }
            }
            .padding()
        }
    }
}

struct Answer: View {
    var option: String
    
    var body: some View {
        Text(option)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
    }
}

#Preview {
    Question(question: ModelData.sampleQuestion)
}
