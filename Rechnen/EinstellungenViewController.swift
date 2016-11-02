//
//  EinstellungenViewController.swift
//  Rechnen
//
//  Created by René Lieb on 27.10.16.
//  Copyright © 2016 René Lieb. All rights reserved.
//

import Cocoa

class EinstellungenViewController: NSViewController {

    @IBOutlet weak var operationAdditionButton: NSButton!
    @IBOutlet weak var operationSubtraktionButton: NSButton!
    @IBOutlet weak var operationMultiplikationButton: NSButton!
    @IBOutlet weak var operationDivisionButton: NSButton!
    
    @IBOutlet weak var zahlenreihe1Button: NSButton!
    @IBOutlet weak var zahlenreihe2Button: NSButton!
    @IBOutlet weak var zahlenreihe3Button: NSButton!
    @IBOutlet weak var zahlenreihe4Button: NSButton!
    @IBOutlet weak var zahlenreihe5Button: NSButton!
    @IBOutlet weak var zahlenreihe6Button: NSButton!
    @IBOutlet weak var zahlenreihe7Button: NSButton!
    @IBOutlet weak var zahlenreihe8Button: NSButton!
    @IBOutlet weak var zahlenreihe9Button: NSButton!
    @IBOutlet weak var zahlenreihe10Button: NSButton!
    
    @IBOutlet weak var anzahlAufgabenTextField: NSTextField!
    @IBOutlet weak var maximaleZeitTextField: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RechnenPreferences.sharedInstance.loadDefaults()
        updateUI()
    }
 
    @IBAction func OkButtonPressed(_ sender: AnyObject) {
        updateModel()
        RechnenPreferences.sharedInstance.saveDefaults()
        
        self.dismiss(self)
    }
    
    @IBAction func AbbrechenButtonPressed(_ sender: AnyObject) {
        self.dismiss(self)
    }
  
    
    private func updateModel() {
        setOperation (button: operationAdditionButton,       operation: Rechnung.Operation.Addition)
        setOperation (button: operationSubtraktionButton,    operation: Rechnung.Operation.Subtraktion)
        setOperation (button: operationMultiplikationButton, operation: Rechnung.Operation.Multiplikation)
        setOperation (button: operationDivisionButton,       operation: Rechnung.Operation.Division)
        
        setOperand (button: zahlenreihe1Button)
        setOperand (button: zahlenreihe2Button)
        setOperand (button: zahlenreihe3Button)
        setOperand (button: zahlenreihe4Button)
        setOperand (button: zahlenreihe5Button)
        setOperand (button: zahlenreihe6Button)
        setOperand (button: zahlenreihe7Button)
        setOperand (button: zahlenreihe8Button)
        setOperand (button: zahlenreihe9Button)
        setOperand (button: zahlenreihe10Button)
        
        RechnenPreferences.sharedInstance.anzahlAufgaben = anzahlAufgabenTextField.integerValue
        RechnenPreferences.sharedInstance.maximaleZeit   = maximaleZeitTextField.integerValue
    }
    
    private func updateUI() {
        setOperationButton(button: operationAdditionButton,       operation: Rechnung.Operation.Addition)
        setOperationButton(button: operationSubtraktionButton,    operation: Rechnung.Operation.Subtraktion)
        setOperationButton(button: operationMultiplikationButton, operation: Rechnung.Operation.Multiplikation)
        setOperationButton(button: operationDivisionButton,       operation: Rechnung.Operation.Division)
        
        setOperandButton(button: zahlenreihe1Button)
        setOperandButton(button: zahlenreihe2Button)
        setOperandButton(button: zahlenreihe3Button)
        setOperandButton(button: zahlenreihe4Button)
        setOperandButton(button: zahlenreihe5Button)
        setOperandButton(button: zahlenreihe6Button)
        setOperandButton(button: zahlenreihe7Button)
        setOperandButton(button: zahlenreihe8Button)
        setOperandButton(button: zahlenreihe9Button)
        setOperandButton(button: zahlenreihe10Button)
        
        anzahlAufgabenTextField.integerValue = RechnenPreferences.sharedInstance.anzahlAufgaben
        maximaleZeitTextField.integerValue   = RechnenPreferences.sharedInstance.maximaleZeit
    }
    
    
    private func setOperandButton (button: NSButton) {
        button.state  = RechnenPreferences.sharedInstance.operands.contains(button.tag) ? NSOnState : NSOffState
    }
    
    private func setOperationButton (button: NSButton, operation: Rechnung.Operation) {
        button.state = RechnenPreferences.sharedInstance.operations.contains(operation) ? NSOnState : NSOffState
    }
    
    
    private func setOperation (button: NSButton, operation: Rechnung.Operation) {
        if(button.state == NSOnState) {
            RechnenPreferences.sharedInstance.addOperation(operation: operation)
        } else {
            RechnenPreferences.sharedInstance.removeOperation(operation: operation)
        }
    }
    
    private func setOperand (button: NSButton) {
        if(button.state == NSOnState) {
            RechnenPreferences.sharedInstance.addOperand(operand: button.tag)
        } else {
            RechnenPreferences.sharedInstance.removeOperand(operand: button.tag)
        }
    }

}
