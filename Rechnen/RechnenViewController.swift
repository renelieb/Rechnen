//
//  ViewController.swift
//  Rechnen
//
//  Created by René Lieb on 27.10.16.
//  Copyright © 2016 René Lieb. All rights reserved.
//

import Cocoa

class RechnenViewController: NSViewController, NSWindowDelegate {
  
    //--- Übungsstand Box ----------------------------------------------------
    @IBOutlet weak var übungsstandBox: NSBox!
    @IBOutlet weak var richtigGelösteAufgabenLabel: NSTextField!
    @IBOutlet weak var richtigGelösteAufgabenProgressIndicator: NSProgressIndicator!
    @IBOutlet weak var falschGelösteAufgabenLabel: NSTextField!
    @IBOutlet weak var verbrauchteZeitLabel: NSTextField!
    @IBOutlet weak var verbrauchteZeitProgressIndicator: NSProgressIndicator!

    //--- Aufgaben Box -------------------------------------------------------
    @IBOutlet weak var aufgabenBox: NSBox!
    @IBOutlet weak var operand1TextField: NSTextField!
    @IBOutlet weak var operationLabel: NSTextField!
    @IBOutlet weak var operand2TextField: NSTextField!
    @IBOutlet weak var resultTextField: NSTextField!
    @IBOutlet weak var weiterButton: NSButton!
    
    var questionField: NSTextField?         // reference to operand1TextField, operand2 or resultTextField

    
    // --- Übung -------------------------------------------------------------
    var übung = Übung()
    
    // --- Timer -------------------------------------------------------------
    var ütimer = CustomTimer()
    var verbrauchteZeit = 0.0               // TODO kann möglicherweise weggelassen werden, da im üTimer abgefragt werden kann
    var btimer = CustomTimer()


    //--- view functions -----------------------------------------------------
    
    override func viewDidLoad() {
        
        //--- set übung
        übung.beendeÜbungCallback = übungBeenden
        übung.neueAufgabe(start: verbrauchteZeit)
        updateUI_Aufgabe()
        
        //--- set timers
        ütimer.name = "ütimer"
        ütimer.fortschrittCallback = updateUI_Zeit
        ütimer.endeCallback = übungBeenden
        ütimer.timeMaximum = Double(RechnenPreferences.sharedInstance.maximaleZeit)
        ütimer.start()

        btimer.name = "btimer"
        btimer.endeCallback = antwortBestätigen
        btimer.timeMaximum = 0.5
    }
    
    override func viewDidAppear() {
        questionField?.becomeFirstResponder()
    }

    override func viewWillDisappear() {
        ütimer.stop()
    }

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "bewerten" {
            if let bewertenViewController = segue.destinationController as? BewertenViewController {
                bewertenViewController.übung = übung
            }
        }
    }
    

    //--- action functions ---------------------------------------------------
    
    @IBAction func weiterButtonPressed(_ sender: AnyObject) {
        print("view.weiterButtonPressed: übung.status=\(übung.status)")
        
        switch übung.status {
            case Übung.Status.aufgabeGestellt:      aufgabeBeantworten()
            case Übung.Status.aufgabeBeantwortet:   antwortBestätigen()
            default:                                print("*** holy shit")
        }
    }
    
    //--- functions ----------------------------------------------------------
    
    func aufgabeBeantworten() {
        print("view.aufgabeBeantworten")

        let answer:Int? = (questionField?.stringValue.characters.count)! > 0 ? questionField?.integerValue : nil
        übung.aufgabeBeantworten(antwort: answer)
        updateUI_Antwort()
        
//        btimer.start()
    }

    func antwortBestätigen() {
        print("view.antwortBestätigen")

//        btimer.stop()

        übung.aufgabeBestägigen(ende: verbrauchteZeit)
        
        übung.neueAufgabe(start: verbrauchteZeit)
        updateUI_Aufgabe()
    }

    func übungBeenden() {
        print("übungBeenden")
        self.performSegue(withIdentifier: "bewerten", sender: self)
    }
    

    // --- update UI functions -----------------------------------------------

    func updateUI_Aufgabe() {
        print("view.updateUI_Aufgabe")
        let rechnung = übung.letzteAufgabe!.rechnung
        
        switch rechnung.questionTerm {
        case 1:  questionField = operand1TextField
        case 2:  questionField = operand2TextField
        default: questionField = resultTextField
        }
        
        setTextField(textField: operand1TextField, value: rechnung.operand1)
        setTextField(textField: operand2TextField, value: rechnung.operand2)
        setTextField(textField: resultTextField,   value: rechnung.result)
        operationLabel.stringValue = (rechnung.operation?.rawValue)!
        
        aufgabenBox.layer?.backgroundColor = nil
        weiterButton.title = "Lösung"
    }
    
    func updateUI_Antwort() {
        print("view.updateUI_Antwort")
        
        //--- update Übungsstand Box ----------------------------------------------------
        
        if (übung.letzteAufgabe?.gelöst)! {
            aufgabenBox.layer?.backgroundColor = CGColor(red: 0.8, green: 1.0, blue: 0.8, alpha: 0.5)
            richtigGelösteAufgabenLabel.integerValue = übung.anzahlRichtigGelösteAufgaben
            richtigGelösteAufgabenProgressIndicator.doubleValue = 100 * Double(übung.anzahlRichtigGelösteAufgaben)
                / Double(RechnenPreferences.sharedInstance.anzahlAufgaben)
        }
        else {
            aufgabenBox.layer?.backgroundColor = CGColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 0.5)
            falschGelösteAufgabenLabel.integerValue = übung.anzahlFalschGelösteAufgaben
        }
        
        //--- update Aufgaben Box -------------------------------------------------------
        questionField = nil
        let rechnung = übung.letzteAufgabe?.rechnung
        setTextField(textField: operand1TextField, value: rechnung!.operand1)
        setTextField(textField: operand2TextField, value: rechnung!.operand2)
        setTextField(textField: resultTextField,   value: rechnung!.result)
        
        weiterButton.title = "nächste Rechnung"
    }
    
    func updateUI_Zeit(_ zeit: Double) {
        verbrauchteZeit = zeit.roundToDecimal(fractionDigits: 1)
        verbrauchteZeitLabel.stringValue = "\(verbrauchteZeit) sec"
        verbrauchteZeitProgressIndicator.doubleValue = 100 * zeit / Double(RechnenPreferences.sharedInstance.maximaleZeit)
    }

    
    // --- Hilfsfunktionen ---------------------------------------------------

    func setTextField(textField: NSTextField, value: Int) {
        let isQuestionField: Bool = (textField == questionField)
        if isQuestionField {
            textField.stringValue = ""
        }
        else {
            textField.intValue    = Int32(value)
        }
        textField.isEditable      = isQuestionField
        textField.isSelectable    = isQuestionField
        textField.drawsBackground = isQuestionField
        textField.backgroundColor = NSColor.clear
        textField.selectText(nil)
    }
    
}
