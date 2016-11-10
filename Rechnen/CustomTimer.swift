//
//  ÜbungTimer.swift
//  Rechnen
//
//  Created by René Lieb on 03.11.16.
//  Copyright © 2016 René Lieb. All rights reserved.
//

import Foundation


class CustomTimer {

    private var timer = Timer()
    private var running = false
    var name  = "timer"
    
    let timeInterval = 0.1
    var time         = 0.0
    var timeMaximum  = 0.0
    
    var fortschrittCallback: ((Double) -> ())?
    var endeCallback:        (() -> ())?
    
    
    func start() {
        running =  true
        time = 0.0
        timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                     target:self,
                                     selector: #selector(CustomTimer.update),
                                     userInfo: nil,
                                     repeats: true)
        print("\(name).start")
    }
    
    func stop() {
        print("\(name).stop running:\(running)")
        if running {
            timer.invalidate()
            running = false
            endeCallback?()
        }
    }
    
    @objc private func update() {
        time += timeInterval
        fortschrittCallback?(time)
        
        if time >= timeMaximum {
            stop()
        }
    }
    
}
