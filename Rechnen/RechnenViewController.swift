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
    
    
    //--- view functions -----------------------------------------------------
    override func viewDidLoad() {
        timerStatus = TimerStatus.gestartet
        aufgabenStatus = AufgabenStatus.gestellt
    }
    
    override func viewDidAppear() {
        questionField?.becomeFirstResponder()
    }

    override func viewWillDisappear() {
        timerStatus = TimerStatus.gestoppt
    }

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "bewerten" {
            if let bewertenViewController = segue.destinationController as? BewertenViewController {
                bewertenViewController.übung = übung
            }
        }
    }
    

    // --- Übung -------------------------------------------------------------
    var übung: Übung = Übung()
    var übungBeendet = false {
        didSet {
            if übungBeendet {
                übung.benötigteZeit = übungsDauerInSekunden
                
                self.performSegue(withIdentifier: "bewerten", sender: self)
            }
        }
    }
    

    // --- Aufgabe -----------------------------------------------------------
    var questionField: NSTextField?
    var rechnung: Rechnung? {
        didSet {
            switch rechnung!.questionTerm {
            case 1:  questionField = operand1TextField
            case 2:  questionField = operand2TextField
            default: questionField = resultTextField
            }
        }
    }

    enum AufgabenStatus {case gestellt, beantwortet}
    var aufgabenStatus = AufgabenStatus.gestellt {
        didSet {
            switch aufgabenStatus {
            case .gestellt:
                aufgabenStart = übungsDauerInSekunden
                
                rechnung = RechnungFabrik.sharedInstance.createRechnung()
                gestellteAufgaben += 1
                
                setTextField(textField: operand1TextField, value: rechnung!.operand1)
                setTextField(textField: operand2TextField, value: rechnung!.operand2)
                setTextField(textField: resultTextField,   value: rechnung!.result)
                operationLabel.stringValue = (rechnung!.operation?.rawValue)!

                aufgabenBox.layer?.backgroundColor = nil
                weiterButton.title = "Lösung"
                
            case .beantwortet:
                aufgabenEnde = übungsDauerInSekunden

                if rechnung!.questionValue == Int((questionField?.intValue)!) {
                    richtigGelösteAufgaben += 1
                }
                else {
                    falschGelösteAufgaben += 1
                }
                
                questionField = nil
                setTextField(textField: operand1TextField, value: rechnung!.operand1)
                setTextField(textField: operand2TextField, value: rechnung!.operand2)
                setTextField(textField: resultTextField,   value: rechnung!.result)
                
                weiterButton.title = "nächste Rechnung"
            }
        }
    }

    var gestellteAufgaben = 0 {
        didSet {
            übung.append(rechnung: rechnung!)
        }
    }
    var aufgabenStart = 0.0
    var aufgabenEnde = 0.0
    var richtigGelösteAufgaben = 0 {
        didSet {
            übung.letzteAufgabeGelöst(antwort: optionalIntegerValue(questionField), dauer: aufgabenEnde - aufgabenStart)

            richtigGelösteAufgabenLabel.intValue = Int32(richtigGelösteAufgaben)
            richtigGelösteAufgabenProgressIndicator.doubleValue = 100 * Double(richtigGelösteAufgaben)
                / Double(RechnenPreferences.sharedInstance.anzahlAufgaben)
            
            lösungsAnzeigeInSekunden = 0
            aufgabenBox.layer?.backgroundColor = CGColor(red: 0.8, green: 1.0, blue: 0.8, alpha: 0.5)
            
            übungBeendet = (richtigGelösteAufgaben == RechnenPreferences.sharedInstance.anzahlAufgaben)
        }
    }
    var falschGelösteAufgaben: Int = 0 {
        didSet {
            übung.letzteAufgabeNichtGelöst(antwort: optionalIntegerValue(questionField), dauer: aufgabenEnde - aufgabenStart)

            falschGelösteAufgabenLabel.integerValue = falschGelösteAufgaben
            
            lösungsAnzeigeInSekunden = 0
            aufgabenBox.layer?.backgroundColor = CGColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 0.5)
        }
    }

    
    @IBAction func weiterButtonPressed(_ sender: AnyObject) {
        aufgabenStatus = (aufgabenStatus == AufgabenStatus.gestellt)
            ? AufgabenStatus.beantwortet
            : AufgabenStatus.gestellt
    }
    
    
    // --- Timer -------------------------------------------------------------
    
    var timer = Timer()
    let timeInterval = 0.1
    
    enum TimerStatus {case gestoppt, gestartet}
    var timerStatus = TimerStatus.gestoppt {
        didSet {
            switch timerStatus {
            case .gestoppt:
                timer.invalidate()

            case .gestartet:
                übungsDauerInSekunden = 0
                timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                             target:self,
                                             selector: #selector(RechnenViewController.updateTime),
                                             userInfo: nil,
                                             repeats: true)
            }
        }
    }
    
    var übungsDauerInSekunden = 0.0 {
        didSet {
            übungsDauerInSekunden = übungsDauerInSekunden.roundToDecimal(fractionDigits: 1)
            
            verbrauchteZeitLabel.stringValue = "\(übungsDauerInSekunden) sec"
            verbrauchteZeitProgressIndicator.doubleValue = 100 * Double(übungsDauerInSekunden)
                / Double(RechnenPreferences.sharedInstance.maximaleZeit)
            
            if (aufgabenStatus == AufgabenStatus.beantwortet) {
                lösungsAnzeigeInSekunden += timeInterval
            }
            
            if übungsDauerInSekunden >= Double(RechnenPreferences.sharedInstance.maximaleZeit) {
                aufgabenEnde = übungsDauerInSekunden
                übung.letzteAufgabeNichtGelöst(antwort: optionalIntegerValue(questionField), dauer: aufgabenEnde - aufgabenStart)
                übungBeendet = true
            }

        }
    }
    
    let maximaleLösungsAnzeige = 0.5
    var lösungsAnzeigeInSekunden = 0.0 {
        didSet {
            if (lösungsAnzeigeInSekunden >= maximaleLösungsAnzeige) {
                aufgabenStatus = AufgabenStatus.gestellt
            }
        }
    }
    
    func updateTime() {
        übungsDauerInSekunden += timeInterval
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
    
    func optionalIntegerValue(_ textField: NSTextField?) -> Int? {
        return questionField?.stringValue.characters.count == 0 ? nil : questionField?.integerValue
    }
    
}
