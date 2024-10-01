import SwiftUI

import Charts

struct DonutChartData: Identifiable {
    let id = UUID()
    let value: Double
    let color: Color
}

struct DonutChart: View {
    let data: [DonutChartData]
    
    var body: some View {
        Chart(data) { item in
            SectorMark(
                angle: .value("Value", item.value),
                innerRadius: .ratio(0.6),
                outerRadius: .ratio(1.0)
            )
            .foregroundStyle(item.color)
        }
        .chartLegend(.hidden)
        .frame(height: 200)
    }
}

struct SuccessView: View {
    @Binding var isPresented: Bool
    var onNewQuestions: () async -> Void
    let answers: Int
    let correctAnswers: Int
    
    private var incorrectAnswers: Int {
        answers - correctAnswers
    }
    
    private var chartData: [DonutChartData] {
        [
            DonutChartData(value: Double(correctAnswers), color: .blue),
            DonutChartData(value: Double(incorrectAnswers), color: Color.blue.opacity(0.1))
        ]
    }
    
    var body: some View {
        VStack(spacing: 20) {
            DonutChart(data: chartData)
                .frame(width: 200, height: 200)
            
            Text("You got \(correctAnswers) out of \(answers) correct!")
                .font(.title2)
                .padding()
            
            Button("Try new questions") {
                isPresented = false
                Task {
                    await onNewQuestions()
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal, 40)
        }
        .padding()
    }
}


struct ContentView: View {
    @StateObject private var modelData = ModelData()
    @State private var selectedAnswers: [String?] = []
    @State private var index = 0
    @State private var allAnswered = false
    
    var correctAnswers : Int {
        var count = 0
        for i in 0...modelData.questions.count - 1{
            if modelData.questions[i].correctAnswer == selectedAnswers[i]{
                count += 1
            }
        }
        return count
    }
    
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
                SuccessView(isPresented: $allAnswered, onNewQuestions: fetchNewQuestions, answers: modelData.questions.count, correctAnswers: correctAnswers)
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
