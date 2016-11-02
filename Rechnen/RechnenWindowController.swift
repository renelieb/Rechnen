//
//  RechnenWindowController.swift
//  Rechnen üben
//
//  Created by René Lieb on 26.10.16.
//  Copyright © 2016 René Lieb. All rights reserved.
//

import Cocoa

class RechnenWindowController: NSWindowController, NSWindowDelegate {

    func windowDidEndSheet(_ notification: Notification) {
        let containerViewController = self.contentViewController as! ContainerViewController
        containerViewController.updateUI()
    }
        
}
