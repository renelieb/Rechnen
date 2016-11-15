
//
//  Rechnung.swift
//  Rechnen üben
//
//  Created by René Lieb on 30.09.16.
//  Copyright © 2016 René Lieb. All rights reserved.
//

import Foundation

class Rechnung: CustomStringConvertible {
    
    enum Operation: String {
        case Addition = "+"
        case Subtraktion = "-"
        case Multiplikation = "x"
        case Division = ":"
    }

    var operation: Operation

    var operand1: Int
    var operand2: Int
    var result: Int
    
    var questionTerm: Int = 0
    var questionValue: Int {
        get {
            switch questionTerm {
            case 1:  return operand1
            case 2:  return operand2
            default: return result
            }
        }
    }

    
    init(value1: Int, value2: Int, operation: Rechnung.Operation) {
        self.operation = operation
        switch (operation) {
        case .Addition:       self.operand1 = value1;          self.operand2 = value2; self.result = operand1 + operand2
        case .Subtraktion:    self.operand1 = value1 + value2; self.operand2 = value2; self.result = operand1 - operand2
        case .Multiplikation: self.operand1 = value1;          self.operand2 = value2; self.result = operand1 * operand2
        case .Division:       self.operand1 = value1 * value2; self.operand2 = value2; self.result = operand1 / operand2
        }
        
        questionTerm = Int(arc4random_uniform(3) + 1)
    }
    
    var description:String {
        return "\(operand1) \(operation.rawValue) \(operand2) = \(result)"
    }

}


class RechnungFabrik {
    
    class func createRechnung() -> Rechnung {
        RechnenPreferences.sharedInstance.loadDefaults()
        
        return Rechnung(value1:    randomOperand(operands: RechnenPreferences.sharedInstance.allOperands),
                        value2:    randomOperand(operands: RechnenPreferences.sharedInstance.operands),
                        operation: randomOperation(operations: RechnenPreferences.sharedInstance.operations))
    }
    
    private class func randomOperand(operands: [Int]) -> Int {
        let randomOperandPosition = Int(arc4random_uniform(UInt32(operands.count)))
        
        return operands[randomOperandPosition]
    }
    
    private class func randomOperation(operations: [Rechnung.Operation]) -> Rechnung.Operation {
        let randomOperandPosition = Int(arc4random_uniform(UInt32(operations.count)))
        
        return operations[randomOperandPosition]
    }
    
}

