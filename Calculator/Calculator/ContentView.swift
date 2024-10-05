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

struct Calculator: View {
    
    var body: some View {
        VStack{
            IntergerButton(
        }
    }
}


struct IntergerButton: View {
    @Binding var total : Int
    var value : Int
    var body: some View {
        Button{
            total = total * 10 + value
        } label: {
            Text("\(value)")
        }
        
    }
}

#Preview {
    ContentView()
}
