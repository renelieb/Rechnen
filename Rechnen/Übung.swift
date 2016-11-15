//
//  Übung.swift
//  Rechnen
//
//  Created by René Lieb on 31.10.16.
//  Copyright © 2016 René Lieb. All rights reserved.
//

import Foundation


class Übung: CustomStringConvertible {

    var aufgaben: [Aufgabe] = []
    var aufgabe: Aufgabe?                 { get { return aufgaben.last } }
    
    var anzahlGestellteAufgaben: Int      { get { return aufgaben.count } }
    var anzahlRichtigGelösteAufgaben: Int { get { return aufgaben.reduce(0, { $1.gelöst ? $0 + 1 : $0} ) } }
    var anzahlFalschGelösteAufgaben: Int  { get { return aufgaben.reduce(0, { $1.gelöst ? $0 : $0 + 1} ) } }
    var dauer: Double                     { get { return aufgaben.reduce(0, { $1.dauer != nil ? $0 + $1.dauer! : $0 } ) } }

    var bestanden: Bool                   { get { return anzahlRichtigGelösteAufgaben == RechnenPreferences.sharedInstance.anzahlAufgaben } }
    var zeitAbgelaufen: Bool              { get { return dauer >= Double(RechnenPreferences.sharedInstance.maximaleZeit) } }
    var beendet: Bool                     { get { return bestanden || zeitAbgelaufen } }
 
    var description:String {
        return "aufgaben: \(aufgaben) # gestellte Aufgaben: \(anzahlGestellteAufgaben) # richtig gelöste Aufgaben: \(anzahlRichtigGelösteAufgaben) # falsch gelöste Aufgaben: \(anzahlFalschGelösteAufgaben) dauer: \(dauer) bestanden: \(bestanden)"
    }
    
    
    // --- Timer für die Übungsdauer -----------------------------------------
    var timer = CustomTimer(name: "ütimer", timeMaximum: Double(RechnenPreferences.sharedInstance.maximaleZeit))

    init() {
        timer.fortschrittCallback = timerAktualisiert
        timer.endeCallback        = timerAbgelaufen
        timer.start()
    }
    
    func timerAktualisiert(zeit: Double) {
        fortschrittCallback?(zeit)
    }
    
    func timerAbgelaufen() {
        if !bestanden {
            antwortBestätigen()
            
            endeCallback?()
        }
    }
    

    // --- callback functions ------------------------------------------------
    var fortschrittCallback: ((Double) -> ())?
    var endeCallback: (() -> ())?

    
    // --- model functions ---------------------------------------------------
    func neueAufgabe() {
        aufgaben.append( Aufgabe(start: timer.time) )
    }
    
    func aufgabeBeantworten(antwort: Int?) {
        aufgabe?.beantworten(antwort: antwort)
    }

    func antwortBestätigen() {
        aufgabe?.bestätigen(time: timer.time)
        
        if bestanden {
            timer.stop()
        }
    }

}


class Aufgabe: CustomStringConvertible {
    var rechnung: Rechnung
    var antwort: Int?
    
    var gestellt: Bool    { get { return antwort == nil } }
    var beantwortet: Bool { get { return antwort != nil } }
    var gelöst: Bool      { get { return antwort == rechnung.questionValue } }
    
    private var aufgabenStart = 0.0
    private var aufgabenEnde  = 0.0
    var dauer: Double?    { get { return aufgabenEnde - aufgabenStart } }
    
    
    init(start: Double) {
        print("aufgabe.init")
        self.rechnung = RechnungFabrik.createRechnung()
        self.aufgabenStart = start
    }
    
    func beantworten(antwort: Int?) {
        print("aufgabe.beantworten")
        self.antwort = antwort
    }
    
    func bestätigen(time: Double) {
        print("aufgabe.bestätigen")
        self.aufgabenEnde = time
    }


    var description:String {
        return "rechnung: \(descriptionRechnung) antwort: \(antwort) dauer: \(dauer) gelöst: \(gelöst)"
    }
    
    var descriptionRechnung: String {
        let operand1  = rechnung.questionTerm == 1 ? "?" : String(rechnung.operand1)
        let operation = (rechnung.operation.rawValue)
        let operand2  = rechnung.questionTerm == 2 ? "?" : String(rechnung.operand2)
        let result    = rechnung.questionTerm == 3 ? "?" : String(rechnung.result)
        return "\(operand1) \(operation) \(operand2) = \(result)"
    }

}

