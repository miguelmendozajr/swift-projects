//
//  ContentView.swift
//  Quiz
//
//  Created by Miguel Mendoza on 27/09/24.
//

import SwiftUI

struct ContentView: View {    
    @StateObject private var modelData = ModelData()
    var body: some View {
        NavigationView{
            List(modelData.questions){ question in
                Question(question: question)
            }
            .navigationTitle("Questions")
        }
        .task {
            await modelData.fetchQuestions()
            
        }
    }
}

#Preview {
    ContentView()
    
}
