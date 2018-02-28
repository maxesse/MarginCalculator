//
//  ViewController.swift
//  MarginCalculator
//
//  Created by Max Sanna on 28/02/2018.
//  Copyright © 2018 Max Sanna. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextFieldDelegate {
    
    
    //MARK: Outlets and variables initialisation
    
    @IBOutlet weak var costField: NSTextField!
    @IBOutlet weak var marginField: NSTextField!
    @IBOutlet weak var revenueField: NSTextField!
    @IBOutlet weak var profitField: NSTextField!
    
    var lastEditedField : String = ""
    
    //MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        costField.delegate = self
        marginField.delegate = self
        revenueField.delegate = self
        profitField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    //MARK: NSTextField Delegate Functions
    
    override func controlTextDidChange(_ obj: Notification) {

        if let editedTextField = obj.object as? NSTextField {
            replaceWithNumbers(withField: editedTextField)
        }
    }
    
    override func controlTextDidEndEditing(_ obj: Notification) {
        if let editedTextField = obj.object as? NSTextField {
            
            lastEditedField = String(describing: editedTextField.identifier!.rawValue)
            print(lastEditedField)
        }
    }
    
    //MARK: Calculation Functions
    
    //MARK: Formatting Functions
    
    func replaceWithNumbers(withField editedTextField : NSTextField) {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        let range = editedTextField.stringValue.rangeOfCharacter(from: invalidCharacters)
        if range == nil {
            print(editedTextField.identifier!.rawValue, editedTextField.stringValue)
        } else {
            switch editedTextField.identifier!.rawValue {
            case "cost":
                costField.stringValue.remove(at: costField.stringValue.index(before: costField.stringValue.endIndex) )
            case "margin":
                marginField.stringValue.remove(at: marginField.stringValue.index(before: marginField.stringValue.endIndex) )
            case "revenue":
                revenueField.stringValue.remove(at: revenueField.stringValue.index(before: revenueField.stringValue.endIndex) )
            case "profit":
                profitField.stringValue.remove(at: profitField.stringValue.index(before: profitField.stringValue.endIndex) )
            default:
                print("Could not find edited field name")
            }
        }
    }
    
    //MARK: Reset Button
    
    @IBAction func resetButtonPressed(_ sender: NSButton) {
        costField.stringValue = ""
        marginField.stringValue = ""
        revenueField.stringValue = ""
        profitField.stringValue = ""
    }
    

}

