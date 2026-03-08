//
//  ContentView.swift
//  DungeonDice
//
//  Created by Wang Sige on 2/15/26.
//

import SwiftUI

struct ContentView: View {
    
    struct DieGroup: Identifiable{
        var id: Int
        let diceLabel: String
        var rollValues: [Int] = []
        var rollString: String {
            rollValues.map{"\($0)"}.joined(separator: ", ")
        }
        var subTotal: Int {rollValues.reduce(0,+)}
    }
    enum Dice: Int, CaseIterable, Identifiable {
        case d4 = 4, d6 = 6, d8 = 8, d10 = 10, d12 = 12, d20 = 20, d100 = 100
        
        var id: Int {self.rawValue}
        var roll: Int {Int.random(in: 1...self.rawValue)}
    }
    @State private var message = "Roll a die!"
    @State private var animationTrigger = false
    @State private var isDoneAnimating = true
    @State private var dieGroups: [DieGroup] = []
    private var grandTotal: Int {dieGroups.reduce(0,{$0+$1.subTotal})}
    
    var body: some View {
        
    
        VStack {
            
            Text("Dungeon Dice!")
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundStyle(.red)
            
            GroupBox {
                ViewThatFits(in: .vertical) {
                    rollList
                    ScrollView{rollList}
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

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 110))]) {
                ForEach(Dice.allCases) { die in
                    Button("\(die.rawValue)-sided") {
                        performRoll(die: die)
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
    
    func performRoll(die:Dice){
        animationTrigger.toggle()
        let roll = die.roll
        message = "You rolled a \(roll) on a \(die)."
        
        withAnimation(.snappy) {
            if let index = dieGroups.firstIndex(where: {$0.id == die.rawValue}){
                dieGroups[index].rollValues.append(roll)
            }else{
                dieGroups.append(DieGroup(id: die.rawValue, diceLabel: "\(die)", rollValues: [roll]))
            }
            dieGroups.sort{$0.id < $1.id}
        }
     
    }
    
    @ViewBuilder
    private var rollList: some View{
        
        LazyVStack(alignment: .leading){
            if dieGroups.isEmpty{
                Text("No rolls yet - tap a die below.")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title3)
                Divider()
            }else{
                ForEach (dieGroups) { dieGroup in
                    HStack{
                        CountBadge(dieCount: dieGroup.rollValues.count)
                        Text(dieGroup.diceLabel)
                            .fontWeight(.semibold)
                            .padding(.trailing,6)
                        Text(dieGroup.rollString)
                            .foregroundStyle(.secondary)
                            .italic()
                        Spacer()
                        Text("\(dieGroup.subTotal)")
                    }
                    .font(.title3)
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .animation(.default, value: dieGroup.subTotal)
                    
                    Divider()
                }
                HStack{
                    Text("TOTAL: \(grandTotal)")
                        .font(.title2)
                        .bold()
                        .monospacedDigit()
                        .contentTransition(.numericText())
                    
                    Spacer()
                    
                    Button("Clear") {
                        withAnimation(.snappy) {
                            dieGroups.removeAll()
                        }
                        
                        message = "Roll a die!"
                    }
                    .buttonStyle(.glass)
                    .tint(.red)
                    .disabled(dieGroups.isEmpty)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
