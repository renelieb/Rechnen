//
//  Einstellungen.swift
//  Rechnen üben
//
//  Created by René Lieb on 04.10.16.
//  Copyright © 2016 René Lieb. All rights reserved.
//

import Foundation

class RechnenPreferences: CustomStringConvertible {
    
    static let sharedInstance: RechnenPreferences = RechnenPreferences()
    

    let allOperands = [0,1,2,3,4,5,6,7,8,9,10]
    var operands: [Int] = []
    var operations: [Rechnung.Operation] = []

    var anzahlAufgaben = 0
    var maximaleZeit = 0
    
    var operationsText: String {
        get {
            var result = ""
            for operation in 0...operations.count-1 {
                result += "\(operation)   "
            }
            return result
        }
    }
    
    var description:String {
        return "operands: \(operands) operations: \(operations) aufgaben: \(anzahlAufgaben) zeit: \(maximaleZeit)"
    }
    
    
    func addOperand (operand: Int) {
        if (!operands.contains(operand)) {
            operands.append(operand)
        }
    }
    
    func removeOperand (operand: Int) {
        operands = operands.filter { $0 != operand }
    }

    func addOperation (operation: Rechnung.Operation) {
        if (!operations.contains(operation)) {
            operations.append(operation)
        }
    }
    
    func removeOperation (operation: Rechnung.Operation) {
        operations = operations.filter { $0 != operation }
    }

    
    //--- persistance of preferences: save to and load from UserDefaults -----------------
    
    func saveDefaults () {
        let defaults = UserDefaults.standard
        for index in 1...10 {
            defaults.set(operands.contains(index), forKey: "Zahlenreihe \(index)")
        }
        defaults.set(operations.contains(Rechnung.Operation.Addition), forKey: "Addition")
        defaults.set(operations.contains(Rechnung.Operation.Subtraktion), forKey: "Subtraktion")
        defaults.set(operations.contains(Rechnung.Operation.Multiplikation), forKey: "Multiplikation")
        defaults.set(operations.contains(Rechnung.Operation.Division), forKey: "Division")
        
        defaults.set(String(anzahlAufgaben), forKey: "Anzahl Aufgaben")
        defaults.set(maximaleZeit, forKey: "Maximale Zeit")
    }

    func loadDefaults () {
        let defaults = UserDefaults.standard
        
        for index in 1...10 {
            if(defaults.bool(forKey: "Zahlenreihe \(index)")) {
                self.addOperand(operand: index)
            } else {
                self.removeOperand(operand: index)
            }
        }
        if defaults.bool(forKey: "Addition") {self.addOperation(operation: Rechnung.Operation.Addition)}
        if defaults.bool(forKey: "Subtraktion") {self.addOperation(operation: Rechnung.Operation.Subtraktion)}
        if defaults.bool(forKey: "Multiplikation") {self.addOperation(operation: Rechnung.Operation.Multiplikation)}
        if defaults.bool(forKey: "Division") {self.addOperation(operation: Rechnung.Operation.Division)}

        self.anzahlAufgaben = defaults.integer(forKey: "Anzahl Aufgaben")
        self.maximaleZeit = defaults.integer(forKey: "Maximale Zeit")
    }

}
