//
//  NumberFormatter.swift
//  BasicML
//
//  Created by Petar  on 1.3.25..
//

import Foundation

extension NumberFormatter {
    
    static var percentage: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        return formatter
    }
}
