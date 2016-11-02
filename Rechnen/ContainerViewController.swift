//
//  ViewController.swift
//  ViewSwitchTest
//
//  Created by René Lieb on 27.10.16.
//  Copyright © 2016 René Lieb. All rights reserved.
//

import Cocoa

class ContainerViewController: NSViewController {
    
    //--- Übungsinfo Box -----------------------------------------------------
    @IBOutlet weak var containerView: NSView!
    
    @IBOutlet weak var AdditionImage: NSImageView!
    @IBOutlet weak var SubtractionImage: NSImageView!
    @IBOutlet weak var MultiplicationImage: NSImageView!
    @IBOutlet weak var DivisionImage: NSImageView!
    @IBOutlet weak var aufgabenLabel: NSTextField!
    @IBOutlet weak var zahlenreihenLabel: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //--- set StartViewController as firstView ------------------------------------
        let mainStoryboard: NSStoryboard = NSStoryboard(name: "Main", bundle: nil)

        let firstViewController = mainStoryboard.instantiateController(withIdentifier: "StartViewController")
        self.insertChildViewController(firstViewController as! NSViewController, at: 0)
        
        let firstView: NSView = (firstViewController as AnyObject).view
        containerView.addSubview(firstView)
        containerView.frame = firstView.frame
        
        updateUI()
    }

    
    func updateUI() {
        RechnenPreferences.sharedInstance.loadDefaults()

        AdditionImage.isHidden       = !RechnenPreferences.sharedInstance.operations.contains(Rechnung.Operation.Addition)
        SubtractionImage.isHidden    = !RechnenPreferences.sharedInstance.operations.contains(Rechnung.Operation.Subtraktion)
        MultiplicationImage.isHidden = !RechnenPreferences.sharedInstance.operations.contains(Rechnung.Operation.Multiplikation)
        DivisionImage.isHidden       = !RechnenPreferences.sharedInstance.operations.contains(Rechnung.Operation.Division)
        
        zahlenreihenLabel.stringValue = zahlenreihen()
        aufgabenLabel.stringValue     = aufgabe()
    }

    
    func zahlenreihen() -> String {
        RechnenPreferences.sharedInstance.operands.sort()

        var result = ""
        for i in 0...RechnenPreferences.sharedInstance.operands.count-1 {
            result += "\(RechnenPreferences.sharedInstance.operands[i])   "
        }
        return result
    }

    func aufgabe() -> String {
        return "Du musst \(RechnenPreferences.sharedInstance.anzahlAufgaben) Aufgaben in \(RechnenPreferences.sharedInstance.maximaleZeit) Sekunden richtig lösen."
    }
}
