//
//  ContentView.swift
//  Calculator
//
//  Created by Miguel Mendoza on 04/10/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
        }
        .padding()
    }
}



#Preview {
    print(evaluate(tokens: ["3", "+", "5", "*", "(", "2", "-", "4", ")", "/","2"]))
    ContentView()
}
