import SwiftUI

struct SuccessView: View {
    @Binding var isPresented: Bool
    var onNewQuestions: () async -> Void

    var body: some View {
        VStack {
            Text("Form submitted successfully!")
            Button("Try new questions") {
                isPresented = false
                Task {
                    await onNewQuestions()
                }
            }
        }
    }
}

struct ContentView: View {
    @StateObject private var modelData = ModelData()
    @State private var selectedAnswers: [String?] = []
    @State private var index = 0
    @State private var allAnswered = false
    
    var body: some View {
        NavigationView {
            VStack {
                if !modelData.questions.isEmpty {
                    questionView
                    Spacer()
                    navigationButtons
                }
            }
            .padding(.bottom, 30)
            .task {
                await fetchNewQuestions()
            }
            .fullScreenCover(isPresented: $allAnswered) {
                SuccessView(isPresented: $allAnswered, onNewQuestions: fetchNewQuestions)
            }
        }
    }
    
    private var questionView: some View {
        Group {
            if index < modelData.questions.count {
                QuestionView(
                    question: modelData.questions[index],
                    selected: Binding(
                        get: { index < selectedAnswers.count ? selectedAnswers[index] : nil },
                        set: { newValue in
                            if index < selectedAnswers.count {
                                selectedAnswers[index] = newValue
                            }
                            allAnswered = !selectedAnswers.contains(nil)
                        }
                    )
                )
            } else {
                Text("No more questions available.")
            }
        }
    }
    
    private var navigationButtons: some View {
        HStack {
            Button(action: {
                if index > 0 {
                    index -= 1
                }
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
                if index < modelData.questions.count - 1 {
                    index += 1
                }
            }, label: {
                Text("Next")
                    .frame(width: 100, height: 40)
                    .bold()
            })
            .disabled(index >= modelData.questions.count - 1)
            .buttonStyle(.borderedProminent)
            .tint(.blue)
        }
        .padding(.horizontal, 30)
    }
    
    private func fetchNewQuestions() async {
        selectedAnswers = []
        index = 0
        allAnswered = false
        await modelData.fetchQuestions()
        selectedAnswers = Array(repeating: nil, count: modelData.questions.count)
    }
}

#Preview {
    ContentView()
}
