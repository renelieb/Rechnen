//
//  Übung.swift
//  Rechnen
//
//  Created by René Lieb on 31.10.16.
//  Copyright © 2016 René Lieb. All rights reserved.
//

import Foundation


class Übung {
    
    enum Status {case aufgabeGestellt, aufgabeBeantwortet, aufgabeBestätigt, übungBeendet}
    var status = Status.aufgabeGestellt
    
    var aufgaben: [Aufgabe] = []
    
    var letzteAufgabe: Aufgabe?           { get { return aufgaben.last } }
    
    var anzahlGestellteAufgaben: Int      { get { return aufgaben.count } }
    var anzahlRichtigGelösteAufgaben: Int { get { return aufgaben.reduce(0, { $1.gelöst ? $0 + 1 : $0} ) } }
    var anzahlFalschGelösteAufgaben: Int  { get { return aufgaben.reduce(0, { $1.gelöst ? $0 : $0 + 1} ) } }
    var benötigteZeit: Double             { get { return aufgaben.reduce(0, { $1.dauer != nil ? $0 + $1.dauer! : $0 } ) } }
    var bestanden: Bool {
        get {
            return anzahlRichtigGelösteAufgaben == RechnenPreferences.sharedInstance.anzahlAufgaben
                || benötigteZeit >= Double(RechnenPreferences.sharedInstance.maximaleZeit)
        }
    }
    
    var description:String {
        return "aufgaben: \(aufgaben) # gestellte Aufgaben: \(anzahlGestellteAufgaben) # richtig gelöste Aufgaben: \(anzahlRichtigGelösteAufgaben) # falsch gelöste Aufgaben: \(anzahlFalschGelösteAufgaben) benötigteZeit: \(benötigteZeit) bestanden: \(bestanden)"
    }
    

    func neueAufgabe(start: Double) {
        let rechnung = RechnungFabrik.sharedInstance.createRechnung()
        let aufgabe = Aufgabe(rechnung: rechnung, start: start)
        aufgaben.append(aufgabe)
        status = Status.aufgabeGestellt
    }
    
    func aufgabeBeantworten(antwort: Int?) {
        aufgaben[aufgaben.count-1].antwort = antwort
        status = Status.aufgabeBeantwortet
    }

    func aufgabeBestägigen(ende: Double) {
        aufgaben[aufgaben.count-1].aufgabenEnde = ende
        status = Status.aufgabeBestätigt
        
        //--- check, if übung is beendet
        if benötigteZeit >= Double(RechnenPreferences.sharedInstance.maximaleZeit)
        || anzahlRichtigGelösteAufgaben >= RechnenPreferences.sharedInstance.anzahlAufgaben {
            beendeÜbungCallback?()
        }
    }
 
    var beendeÜbungCallback: (() -> ())?
}


class Aufgabe: CustomStringConvertible {
    var rechnung: Rechnung
    var antwort: Int?
    var aufgabenStart = 0.0
    var aufgabenEnde = 0.0
    var dauer: Double? { get { return aufgabenEnde - aufgabenStart } }
    var gelöst: Bool { get { return antwort == rechnung.questionValue } }
    
    init(rechnung: Rechnung, start: Double) {
        self.rechnung = rechnung
        self.aufgabenStart = start
    }
    
    var description:String {
        return "rechnung: \(descriptionRechnung) antwort: \(antwort) dauer: \(dauer) gelöst: \(gelöst)"
    }
    
    var descriptionRechnung: String {
        let operand1  = rechnung.questionTerm == 1 ? "?" : String(rechnung.operand1)
        let operation = (rechnung.operation?.rawValue)!
        let operand2  = rechnung.questionTerm == 2 ? "?" : String(rechnung.operand2)
        let result    = rechnung.questionTerm == 3 ? "?" : String(rechnung.result)
        return "\(operand1) \(operation) \(operand2) = \(result)"
    }

}
