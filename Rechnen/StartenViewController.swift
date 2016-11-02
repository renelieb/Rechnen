//
//  StartenViewController.swift
//  Rechnen
//
//  Created by René Lieb on 31.10.16.
//  Copyright © 2016 René Lieb. All rights reserved.
//

import Cocoa

class StartenViewController: NSViewController {

    @IBOutlet weak var zählrahmenImageView: NSImageView!
    
    var animation: NSViewAnimation = NSViewAnimation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        zählrahmenImageView.wantsLayer = true
        zählrahmenImageView.animator().alphaValue = 0
        zählrahmenImageView.animator().frame = NSRect(x:197, y:191, width:0, height:0)
    }
    
    override func viewDidAppear() {
        blendIn()
    }
    
    override func viewWillDisappear() {
        blendOut()
    }

    func blendIn() {
        NSAnimationContext.runAnimationGroup(
            { (context) -> Void in
                context.duration = 1.0
                self.zählrahmenImageView.animator().alphaValue = 1
                self.zählrahmenImageView.animator().frame = NSRect(x:169, y:63, width:256, height:256)
            }, completionHandler: nil)
    }
    
    func blendOut() {
        NSAnimationContext.runAnimationGroup(
            { (context) -> Void in
                context.duration = 0.3
                self.zählrahmenImageView.animator().frame = NSRect(x:30, y:300, width:0, height:0)
            }, completionHandler: nil)
    }

}
