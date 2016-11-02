//
//  CustomSegue.swift
//  Rechnen
//
//  Created by René Lieb on 28.10.16.
//  Copyright © 2016 René Lieb. All rights reserved.
//

import Cocoa

class CustomSegue: NSStoryboardSegue {

    var transitionOptions: NSViewControllerTransitionOptions = NSViewControllerTransitionOptions.crossfade
    
    
    override init(identifier: String,
                  source sourceController: Any,
                  destination destinationController: Any) {
        super.init(identifier: identifier, source: sourceController, destination: destinationController)
    }
    
    override func perform() {
        let sourceViewController = self.sourceController as! NSViewController
        let destinationViewController = self.destinationController as! NSViewController
        let containerViewController = sourceViewController.parent!
        
        containerViewController.insertChildViewController(destinationViewController, at: 1)
        
        let targetSize = destinationViewController.view.frame.size
        
        containerViewController.view.wantsLayer = true
        sourceViewController.view.wantsLayer = true
        destinationViewController.view.wantsLayer = true
        sourceViewController.view.animator().setFrameSize(targetSize)
        destinationViewController.view.animator().setFrameSize(targetSize)
        
        containerViewController.transition(from: sourceViewController,
                                           to: destinationViewController,
                                           options: transitionOptions,
                                           completionHandler: nil)
        
        containerViewController.removeChildViewController(at: 0)
    }
    
}
