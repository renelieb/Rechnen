//
//  BewertenViewController.swift
//  Rechnen
//
//  Created by René Lieb on 28.10.16.
//  Copyright © 2016 René Lieb. All rights reserved.
//

import Cocoa

class BewertenViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate  {

    @IBOutlet weak var mitteilungLabel: NSTextField!
    @IBOutlet weak var aufgabenTableView: NSTableView!

    @IBOutlet weak var gestellteAufgabenLabel: NSTextField!
    @IBOutlet weak var benötigteZeitLabel: NSTextField!
    @IBOutlet weak var richtigGelöstLabel: NSTextField!
    @IBOutlet weak var falschGelöstLabel: NSTextField!
    
    
    var übung: Übung?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aufgabenTableView.delegate = self
        aufgabenTableView.dataSource = self
    }
    
    override func viewDidAppear() {
        if übung != nil {
            let übungBestandenPrefix1 = (übung?.bestanden)! ? "Gratuliere" : "Schade"
            let übungBestandenPrefix2 = (übung?.bestanden)! ? "" : "nicht "
            
            gestellteAufgabenLabel.stringValue = "Du hast \(übung!.aufgaben.count) Aufgaben erhalten."
            benötigteZeitLabel.stringValue = "In \(übung!.dauer) Sekunden hast du"
            richtigGelöstLabel.stringValue = "\(übung!.anzahlRichtigGelösteAufgaben) Aufgaben richtig gelöst"
            falschGelöstLabel.stringValue = "\(übung!.anzahlFalschGelösteAufgaben) Aufgaben nicht gelöst"
            mitteilungLabel.stringValue = "\(übungBestandenPrefix1), du hast die Übung \(übungBestandenPrefix2)bestanden!"
        }
    }
    
    
    //--- Protocol: NSTableViewDataSource ------------------------------------------------
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return (übung?.aufgaben.count)!
    }
    
    //--- Protocol: NSTableViewDelegate --------------------------------------------------
    
    let okColor  = NSColor(red: 0.8, green: 1.0, blue: 0.8, alpha: 0.5)
    let nokColor = NSColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 0.5)
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let aufgabe:Aufgabe = (übung?.aufgaben[row])!

        func makeTableCell(_ cellIdentifier: String, _ text: String) -> NSTableCellView? {
            if let cell = tableView.make(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView {
                cell.textField?.stringValue = text
                cell.textField?.backgroundColor = aufgabe.gelöst ? okColor : nokColor
                return cell
            }
            return nil
        }
        
        if tableColumn == tableView.tableColumns[0] {
            return makeTableCell("AufgabeCellID", aufgabe.descriptionRechnung)
        } else if tableColumn == tableView.tableColumns[1] {
            return makeTableCell("LösungCellID", aufgabe.antwort == nil ? "" : String(aufgabe.antwort!))
        } else if tableColumn == tableView.tableColumns[2] {
            return makeTableCell("ZeitCellID", aufgabe.dauer != nil ? String(format:"%.1f sec", aufgabe.dauer!) : "")
        }
        return nil
    }

}
