//
//  Übung.swift
//  Rechnen
//
//  Created by René Lieb on 31.10.16.
//  Copyright © 2016 René Lieb. All rights reserved.
//

import Foundation


struct Übung: CustomStringConvertible {
    var aufgaben: [Aufgabe] = []
    var benötigteZeit: Double = 0.0
    
    mutating func append(rechnung: Rechnung) {
        aufgaben.append(Aufgabe(rechnung: rechnung))
    }

    mutating func letzteAufgabeGelöst(antwort: Int?, dauer: Double) {
        aufgaben[aufgaben.count-1].antwort = antwort
        aufgaben[aufgaben.count-1].dauer = dauer
        aufgaben[aufgaben.count-1].gelöst = true
    }
    
    mutating func letzteAufgabeNichtGelöst(antwort: Int?, dauer: Double) {
        aufgaben[aufgaben.count-1].antwort = antwort
        aufgaben[aufgaben.count-1].dauer = dauer
        aufgaben[aufgaben.count-1].gelöst = false
    }
    
    var gestellteAufgaben: Int {
        get {
            return aufgaben.count
        }
    }
    
    var richtigGelösteAufgaben: Int {
        get {
            var result = 0
            for aufgabe in aufgaben {
                if aufgabe.gelöst { result += 1 }
            }
            return result
        }
    }
    
    var falschGelösteAufgaben: Int {
        get {
            var result = 0
            for aufgabe in aufgaben {
                if !aufgabe.gelöst { result += 1 }
            }
            return result
        }
    }
    
    var bestanden: Bool {
        get {
            return benötigteZeit < Double(RechnenPreferences.sharedInstance.maximaleZeit)
        }
    }

    var description:String {
        return "aufgaben: \(aufgaben) benötigteZeit: \(benötigteZeit) gestellteAufgaben: \(gestellteAufgaben) richtigGelösteAufgaben: \(richtigGelösteAufgaben) falschGelösteAufgaben: \(falschGelösteAufgaben) bestanden: \(bestanden)"
    }
}


struct Aufgabe: CustomStringConvertible {
    var rechnung: Rechnung
    var antwort: Int?
    var dauer: Double?
    var gelöst: Bool = false
    
    init(rechnung: Rechnung) {
        self.rechnung = rechnung
    }
    
    var description:String {
        return "aufgabe: \(descriptionAufgabe) antwort: \(antwort) dauer: \(dauer!) gelöst: \(gelöst)"
    }
    
    var descriptionAufgabe: String {
        var result = ""
        result += rechnung.questionTerm == 1 ? "?" : String(rechnung.operand1)
        result += " \((rechnung.operation?.rawValue)!) "
        result += rechnung.questionTerm == 2 ? "?" : String(rechnung.operand2)
        result += " = "
        result += rechnung.questionTerm == 3 ? "?" : String(rechnung.result)
        return result
    }

    var descriptionLösung: String {
        var result = ""
        
        let antwortString = antwort == nil ? "--" : String(antwort!)
        result += rechnung.questionTerm == 1 ? antwortString : String(rechnung.operand1)
        result += (rechnung.operation?.rawValue)!
        result += rechnung.questionTerm == 2 ? antwortString : String(rechnung.operand2)
        result += "="
        result += rechnung.questionTerm == 3 ? antwortString : String(rechnung.result)
        
        return result
    }

}
