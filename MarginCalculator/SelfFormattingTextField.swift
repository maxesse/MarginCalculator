//
//  SelfFormattingTextField.swift
//  MarginCalculator
//
//  Created by Max Sanna on 11/03/2018.
//  Copyright © 2018 Max Sanna. All rights reserved.
//

import Cocoa

protocol SelfFormattingTextFieldDelegate: class {
    func textFieldOnFocus(_ textField: SelfFormattingTextField)
}

class SelfFormattingTextField : NSTextField {
    weak var myDelegate: SelfFormattingTextFieldDelegate?
    private var isFirstResponder = false
    
    override func becomeFirstResponder() -> Bool {
        let status = super.becomeFirstResponder()
        if status { isFirstResponder = true }
        return status
    }

    override func resignFirstResponder() -> Bool {
        let status = super.resignFirstResponder()
        
        if status, isFirstResponder, let _ = currentEditor() {
            myDelegate?.textFieldOnFocus(self)
        }
        
        return status
    }

}
