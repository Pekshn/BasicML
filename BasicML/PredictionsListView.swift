//
//  PredictionsListView.swift
//  BasicML
//
//  Created by Petar  on 1.3.25..
//

import SwiftUI

struct PredictionsListView: View {
    
    @Binding var predictions: [String: Double]
    private var sortedProbs: [Dictionary<String, Double>.Element] {
        let probsArray = Array(predictions)
        return probsArray.sorted { lhs, rhs in
            lhs.value > rhs.value
        }
    }
    
    var body: some View {
        List(Array(sortedProbs), id: \.key) { item in
            HStack {
                Text(item.key)
                Spacer()
                Text(NSNumber(value: item.value), formatter: NumberFormatter.percentage)
            }
        }
    }
}

#Preview {
    PredictionsListView(predictions: .constant([:]))
}
