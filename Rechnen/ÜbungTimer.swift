//
//  ÜbungTimer.swift
//  Rechnen
//
//  Created by René Lieb on 03.11.16.
//  Copyright © 2016 René Lieb. All rights reserved.
//

import Foundation

class ÜbungTimer {
    
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
            
//            verbrauchteZeitLabel.stringValue = "\(übungsDauerInSekunden) sec"
//            verbrauchteZeitProgressIndicator.doubleValue = 100 * Double(übungsDauerInSekunden)
                / Double(RechnenPreferences.sharedInstance.maximaleZeit)
            
//            if (aufgabenStatus == AufgabenStatus.beantwortet) {
//                lösungsAnzeigeInSekunden += timeInterval
//            }
            
//            if übungsDauerInSekunden >= Double(RechnenPreferences.sharedInstance.maximaleZeit) {
//                _ = übung.aufgabeBeantwortet(antwort: questionField?.integerValue, ende: übungsDauerInSekunden)
//                übungBeendet = true
//            }
            
        }
    }
    
    let maximaleLösungsAnzeige = 0.5
    var lösungsAnzeigeInSekunden = 0.0 {
        didSet {
            if (lösungsAnzeigeInSekunden >= maximaleLösungsAnzeige) {
//                aufgabenStatus = AufgabenStatus.gestellt
            }
        }
    }
    
    func updateTime() {
        übungsDauerInSekunden += timeInterval
    }

}
