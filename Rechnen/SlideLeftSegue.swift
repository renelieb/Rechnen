//
//  SlideLeftSegue.swift
//  ViewSwitchTest
//
//  Created by René Lieb on 28.10.16.
//  Copyright © 2016 René Lieb. All rights reserved.
//

import Cocoa

class SlideLeftSegue: CustomSegue {

    override init(identifier: String,
                  source sourceController: Any,
                  destination destinationController: Any) {
        super.init(identifier: identifier, source: sourceController, destination: destinationController)

        transitionOptions = NSViewControllerTransitionOptions.slideLeft
    }
    
}
