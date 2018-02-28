//
//  SelfChangingTextField.swift
//  MarginCalculator
//
//  Created by Max Sanna on 28/02/2018.
//  Copyright © 2018 Max Sanna. All rights reserved.
//

import Cocoa

class SelfChangingTextField : NSTextField {
    override func textDidChange(_ notification: Notification) {
        print("Text did change")
    }
}
