//
//  RechnungFabrik.swift
//  Rechnen üben
//
//  Created by René Lieb on 01.10.16.
//  Copyright © 2016 René Lieb. All rights reserved.
//

import Foundation

class RechnungFabrik {
    
    static let sharedInstance: RechnungFabrik = RechnungFabrik()

    
    func createRechnung() -> Rechnung {
        RechnenPreferences.sharedInstance.loadDefaults()
        
        return Rechnung(value1: randomOperand(operands: RechnenPreferences.sharedInstance.allOperands),
                        value2: randomOperand(operands: RechnenPreferences.sharedInstance.operands),
                        operation: randomOperation(operations: RechnenPreferences.sharedInstance.operations))
    }
    
    func randomOperand(operands: [Int]) -> Int {
        let randomOperandPosition = Int(arc4random_uniform(UInt32(operands.count)))

        return operands[randomOperandPosition]
    }

    func randomOperation(operations: [Rechnung.Operation]) -> Rechnung.Operation {
        let randomOperandPosition = Int(arc4random_uniform(UInt32(operations.count)))
        
        return operations[randomOperandPosition]
    }
    
}
