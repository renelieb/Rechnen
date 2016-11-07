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
    var letzteAufgabe: Aufgabe? { get { return aufgaben.last } }

    var anzahlGestellteAufgaben: Int {
        get {
            return aufgaben.count
        }
    }
    var anzahlRichtigGelösteAufgaben: Int {
        get {
            var result = 0
            for aufgabe in aufgaben {
                if aufgabe.gelöst { result += 1 }
            }
            return result
        }
    }
    var anzahlFalschGelösteAufgaben: Int {
        get {
            var result = 0
            for aufgabe in aufgaben {
                if !aufgabe.gelöst { result += 1 }
            }
            return result
        }
    }
    var benötigteZeit: Double = 0.0
    var bestanden: Bool {
        get {
            return benötigteZeit < Double(RechnenPreferences.sharedInstance.maximaleZeit)
        }
    }

    var description:String {
        return "aufgaben: \(aufgaben) benötigteZeit: \(benötigteZeit) # gestellte Aufgaben: \(anzahlGestellteAufgaben) # richtig gelöste Aufgaben: \(anzahlRichtigGelösteAufgaben) # falsch gelöste Aufgaben: \(anzahlFalschGelösteAufgaben) bestanden: \(bestanden)"
    }
    
    mutating func neueAufgabe(start: Double) -> Aufgabe {
        let rechnung = RechnungFabrik.sharedInstance.createRechnung()
        let aufgabe = Aufgabe(rechnung: rechnung, start: start)
        aufgaben.append(aufgabe)

        return aufgabe
    }
    
    mutating func aufgabeBeantworten(antwort: Int?) -> Bool {
        print("übung.aufgabe.antwort: \(antwort)")
        aufgaben[aufgaben.count-1].antwort = antwort
        return aufgaben[aufgaben.count-1].gelöst
    }

    mutating func aufgabeBestägigen(ende: Double) -> Bool {
        print("übung.aufgabe.ende: \(ende)")
        aufgaben[aufgaben.count-1].aufgabenEnde = ende
        benötigteZeit = ende

        let beendet = (anzahlRichtigGelösteAufgaben == RechnenPreferences.sharedInstance.anzahlAufgaben || benötigteZeit >= Double(RechnenPreferences.sharedInstance.maximaleZeit))
        print("beendet: \(beendet)")
        return beendet
    }

}


struct Aufgabe: CustomStringConvertible {
    var rechnung: Rechnung
    var antwort: Int?
    var aufgabenStart = 0.0
    var aufgabenEnde = 0.0
    var dauer: Double? {
        get {
            return aufgabenEnde - aufgabenStart
        }
    }
    var gelöst: Bool {
        get {
            return antwort == rechnung.questionValue
        }
    }
    
    init(rechnung: Rechnung, start: Double) {
        self.rechnung = rechnung
        self.aufgabenStart = start
    }
    
    var description:String {
        return "rechnung: \(descriptionRechnung) antwort: \(antwort) dauer: \(dauer) gelöst: \(gelöst)"
    }
    
    var descriptionRechnung: String {
        var result = ""
        result += rechnung.questionTerm == 1 ? "?" : String(rechnung.operand1)
        result += " \((rechnung.operation?.rawValue)!) "
        result += rechnung.questionTerm == 2 ? "?" : String(rechnung.operand2)
        result += " = "
        result += rechnung.questionTerm == 3 ? "?" : String(rechnung.result)
        return result
    }

}
