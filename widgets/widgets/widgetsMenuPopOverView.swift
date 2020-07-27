//
//  widgetsMenuPopOverView.swift
//  widgets
//
//  Created by Christian Villegas on 7/26/20.
//  Copyright © 2020 Christopher Cordero. All rights reserved.
//

import UIKit

class widgetsMenuPopOverView: UIPopoverBackgroundView {

    override var arrowOffset: CGFloat {
        get {
            return 0.0
        }
        set {
            super.arrowOffset = newValue
        }
    }

    override var arrowDirection: UIPopoverArrowDirection {
        get {
            return UIPopoverArrowDirection.up
        }
        set {
            super.arrowDirection = newValue
        }
    }

    override class func contentViewInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    override class func arrowBase() -> CGFloat {
        return 2.0
    }

    override class func arrowHeight() -> CGFloat {
        return 2.0
    }
    
}
