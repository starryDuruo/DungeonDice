//
//  ContentView.swift
//  DungeonDice
//
//  Created by Wang Sige on 2/15/26.
//

import SwiftUI

struct ContentView: View {
    enum Dice: Int, CaseIterable, Identifiable {
        case d4 = 4, d6 = 6, d8 = 8, d10 = 10, d12 = 12, d20 = 20, d100 = 100
        
        var id: Int {self.rawValue}
        var roll: Int {Int.random(in: 1...self.rawValue)}
    }
    @State private var message = "Roll a die!"
    @State private var animationTrigger = false
    @State private var isDoneAnimating = true
    @State private var rolls: [Int] = []
    private var grandTotal: Int {rolls.reduce(0,+)}
    
    var body: some View {
        VStack {
            
            Text("Dungeon Dice!")
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundStyle(.red)
            
            GroupBox {
                ForEach (rolls, id: \.self) { roll in
                    Text("\(roll)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                }
            
            
            HStack{
                Text("TOTAL: \(grandTotal)")
                    .font(.title2)
                    .bold()
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .animation(.default, value: grandTotal)
                
                Spacer()
                
                Button("Clear") {
                    rolls.removeAll()
                }
                .buttonStyle(.glass)
                .tint(.red)
                .disabled(rolls.isEmpty)
            }
            }label: {
                Text("Session Rolls:")
                    .font(.title2)
                    .bold()
            }
            
            Spacer()
          
            Text(message)
                .font(.title)
                .multilineTextAlignment(.center)
                .rotation3DEffect( isDoneAnimating ? .degrees(360) : .degrees(0), axis: (1,0,0))
                .onChange(of: animationTrigger) { oldValue, newValue in
                    isDoneAnimating = false
                    withAnimation(.interpolatingSpring(duration: 0.6,bounce: 0.4)) {
                        isDoneAnimating = true
                    }
                }
            
            Spacer()
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 110))]) {
                ForEach(Dice.allCases) { die in
                    Button("\(die.rawValue)-sided") {
                        animationTrigger.toggle()
                        let roll = die.roll
                        message = "You rolled a \(roll) on a \(die)."
                        rolls.append(roll)
                    }
                    .font(.title2)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                    .buttonStyle(.glassProminent)
                    .tint(.red)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
