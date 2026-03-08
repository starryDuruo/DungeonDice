//
//  CountBadge.swift
//  DungeonDice
//
//  Created by Wang Sige on 3/8/26.
//

import SwiftUI

struct CountBadge: View {
    let dieCount: Int
    var body: some View {
        Text("\(dieCount)×")
            .font(.callout)
            .fontWeight(.semibold)
            .padding(.horizontal,6)
            .padding(.vertical, 3)
            .background(.red.opacity(0.2), in: Capsule())
            .overlay {
                Capsule().stroke(.red.opacity(0.3), lineWidth: 1)
            }
    }
}

#Preview {
    CountBadge(dieCount:3)
}
