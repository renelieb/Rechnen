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
    private var name  = "timer"
    private var running = false
    
    private let timeInterval = 0.1
    var time         = 0.0
    private var timeMaximum  = 0.0
    
    
    var fortschrittCallback: ((Double) -> ())?
    var endeCallback:        (() -> ())?
    
    
    init(name: String, timeMaximum: Double) {
        self.name = name
        self.timeMaximum = timeMaximum
    }
    
    
    func start() {
        running =  true
        time = 0.0
        timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                     target:self,
                                     selector: #selector(CustomTimer.update),
                                     userInfo: nil,
                                     repeats: true)
//        print("\(name).start")
    }
    
    func stop() {
//        print("\(name).stop running:\(running)")
        if running {
            timer.invalidate()
            running = false
            endeCallback?()
        }
    }
    
    @objc private func update() {
        time += timeInterval
        if time < timeMaximum { fortschrittCallback?(time) }
        else                  { stop() }
    }
    
}
