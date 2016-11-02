//
//  DoubleExtension.swift
//  Rechnen
//
//  Created by René Lieb on 31.10.16.
//  Copyright © 2016 René Lieb. All rights reserved.
//

import Foundation

extension Double {
    
    func roundToDecimal(fractionDigits: Int) -> Double {
        let multiplier = pow(10.0, Double(fractionDigits))
        return (self * multiplier).rounded() / multiplier
    }
    
}
