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

    
    var übung = Übung()
    var antwortTimer = CustomTimer(name: "btimer", timeMaximum: 0.5) // Timer für automatische Bestätigung der Antworten


    //--- view functions -----------------------------------------------------
    
    override func viewDidLoad() {
        
        //--- set callback functions
        übung.fortschrittCallback = übungsForschrittAktualisiert
        übung.endeCallback = übungBeendet
        
        antwortTimer.endeCallback = antwortBestätigt

        übung.neueAufgabe()
        updateUI_Aufgabe()
    }
    
    override func viewDidAppear() {
        questionField?.becomeFirstResponder()
    }

    override func viewWillDisappear() {
        antwortTimer.stop()
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
        print("\n--> view.weiterButtonPressed: übung.status=\(übung.status) \(NSDate())")
        
        switch übung.status {
            case Übung.Status.aufgabeGestellt:      aufgabeBeantworten()
            case Übung.Status.aufgabeBeantwortet:   antwortBestätigen()
            default:                                print("*** holy shit")
        }
    }
    
    
    //--- callback functions -------------------------------------------------
    
    func übungsForschrittAktualisiert(zeit: Double) {
        updateUI_Zeit(zeit)
    }

    func antwortBestätigt() {
        print("\n--> view.antwortBestätigt: übung.status=\(übung.status) \(NSDate())")
        antwortBestätigen()
    }
    
    func übungBeendet() {
        print("\n--> view.übungBeendet: übung.status=\(übung.status) \(NSDate())")
        übungVerlassen()
    }
    

    //--- functions ----------------------------------------------------------
    
    func aufgabeBeantworten() {
        print("view.aufgabeBeantworten \(NSDate())")

        let answer:Int? = (questionField?.stringValue.characters.count)! > 0 ? questionField?.integerValue : nil
        übung.aufgabeBeantworten(antwort: answer)
        updateUI_Antwort()
        updateUI_Stand()
        
        antwortTimer.start()
    }

    func antwortBestätigen() {
        print("view.antwortBestätigen \(NSDate())")
        antwortTimer.stop()

        übung.antwortBestätigen()
        
        if übung.beendet {
            übungVerlassen()
        } else {
            übung.neueAufgabe()
            updateUI_Aufgabe()
        }
    }

    func übungVerlassen() {
        print("view.übungVerlassen \(NSDate())")

        self.performSegue(withIdentifier: "bewerten", sender: self)
    }
    

    // --- update UI functions -----------------------------------------------

    func updateUI_Aufgabe() {
        print("view.updateUI_Aufgabe \(NSDate())")
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
        print("view.updateUI_Antwort \(NSDate())")
        
        questionField = nil
        let rechnung = übung.letzteAufgabe?.rechnung
        setTextField(textField: operand1TextField, value: rechnung!.operand1)
        setTextField(textField: operand2TextField, value: rechnung!.operand2)
        setTextField(textField: resultTextField,   value: rechnung!.result)
        
        weiterButton.title = "nächste Rechnung"
    }

    
    let okColor  = CGColor(red: 0.8, green: 1.0, blue: 0.8, alpha: 0.5)
    let nokColor = CGColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 0.5)

    func updateUI_Stand() {
        print("view.updateUI_Stand \(NSDate())")
        
        if (übung.letzteAufgabe?.gelöst)! {
            aufgabenBox.layer?.backgroundColor = okColor
            richtigGelösteAufgabenLabel.integerValue = übung.anzahlRichtigGelösteAufgaben
            richtigGelösteAufgabenProgressIndicator.doubleValue = 100 * Double(übung.anzahlRichtigGelösteAufgaben)
                / Double(RechnenPreferences.sharedInstance.anzahlAufgaben)
        }
        else {
            aufgabenBox.layer?.backgroundColor = nokColor
            falschGelösteAufgabenLabel.integerValue = übung.anzahlFalschGelösteAufgaben
        }
    }

    func updateUI_Zeit(_ zeit: Double) {
        let dauer = zeit.roundToDecimal(fractionDigits: 1)
        verbrauchteZeitLabel.stringValue             = "\(dauer) sec"
        verbrauchteZeitProgressIndicator.doubleValue = 100 * dauer / Double(RechnenPreferences.sharedInstance.maximaleZeit)
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
