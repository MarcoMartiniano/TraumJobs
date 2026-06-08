//
//  CurrencyFormatter.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 27.02.26.
//

import Foundation

struct CurrencyFormatter {
    
    static func euro(_ value: Double) -> String {
        value.formatted(
            .currency(code: "EUR")
                .precision(.fractionLength(0...2))
        )
    }
}
