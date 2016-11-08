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

    enum ÜbungStatus {case gestartet, beendet}
    var übungStatus = ÜbungStatus.gestartet {
        didSet {
            print("didSet übungStatus: \(übungStatus)")
            if übungStatus == ÜbungStatus.beendet {
                self.performSegue(withIdentifier: "bewerten", sender: self)
            }
        }
    }

    
    // --- Aufgabe -----------------------------------------------------------
    enum AufgabenStatus {case gestellt, beantwortet, bestätigt}
    var aufgabenStatus = AufgabenStatus.gestellt {
        didSet {
            print("didSet aufgabenStatus: \(aufgabenStatus)")

            switch aufgabenStatus {
            case .gestellt:
                //--- update Aufgaben Box -------------------------------------------------------
                let rechnung = übung.neueAufgabe(start: übungsDauerInSekunden).rechnung
                
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
                
            case .beantwortet:
                //--- update Übungsstand Box ----------------------------------------------------
                let answer:Int? = (questionField?.stringValue.characters.count)! > 0 ? questionField?.integerValue : nil

                if übung.aufgabeBeantworten(antwort: answer) {
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
                lösungsAnzeigeInSekunden = 0

                questionField = nil
                let rechnung = übung.letzteAufgabe?.rechnung
                setTextField(textField: operand1TextField, value: rechnung!.operand1)
                setTextField(textField: operand2TextField, value: rechnung!.operand2)
                setTextField(textField: resultTextField,   value: rechnung!.result)
                
                weiterButton.title = "nächste Rechnung"
                
            case .bestätigt:
                if (übung.aufgabeBestägigen(ende: übungsDauerInSekunden)) {
                    print("übung beendet")
                    übungStatus = ÜbungStatus.beendet
                }
            }
        }
    }
    
    @IBAction func weiterButtonPressed(_ sender: AnyObject) {
        switch aufgabenStatus {
        case .gestellt:
            aufgabenStatus = .beantwortet
        case .beantwortet:
            aufgabenStatus = .bestätigt
            aufgabenStatus = .gestellt
        default:
            print("Huch es ist ein Fehler aufgetreten")
        }
        print("weiterButtonPressed aufgabenStatus: \(aufgabenStatus)")
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
            print("übungsdauerInSekunden: \(übungsDauerInSekunden)")
            if übungsDauerInSekunden > 0 {
                übungsDauerInSekunden = übungsDauerInSekunden.roundToDecimal(fractionDigits: 1)
                
                verbrauchteZeitLabel.stringValue = "\(übungsDauerInSekunden) sec"
                verbrauchteZeitProgressIndicator.doubleValue = 100 * Double(übungsDauerInSekunden)
                    / Double(RechnenPreferences.sharedInstance.maximaleZeit)
                
                if (aufgabenStatus == AufgabenStatus.beantwortet) {
                    lösungsAnzeigeInSekunden += timeInterval
                }

                if übungsDauerInSekunden >= Double(RechnenPreferences.sharedInstance.maximaleZeit) {
                    if (übung.aufgabeBestägigen(ende: übungsDauerInSekunden)) {
                        übungStatus = ÜbungStatus.beendet
                    }
                }
            }
        }
    }
    
    let maximaleLösungsAnzeige = 0.5
    var lösungsAnzeigeInSekunden = 0.0 {
        didSet {
            print("didSet lösungsAnzeiegeInSekunden aufgabenStatus: \(aufgabenStatus)")
            if (lösungsAnzeigeInSekunden >= maximaleLösungsAnzeige) {
                aufgabenStatus = AufgabenStatus.bestätigt
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
