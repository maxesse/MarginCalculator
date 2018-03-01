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
    var lastFieldValue : String = ""
    
    //MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        costField.delegate = self
        marginField.delegate = self
        revenueField.delegate = self
        profitField.delegate = self
    }
    
    override func viewWillAppear() {
        costField.becomeFirstResponder()
    }
    
    //MARK: NSTextField Delegate Functions
    
    override func controlTextDidChange(_ obj: Notification) {

        if let editedTextField = obj.object as? NSTextField {
            replaceWithNumbers(withField: editedTextField)
            lastFieldValue = editedTextField.stringValue
            calculate(withField: editedTextField)
        }
    }
    
    override func controlTextDidEndEditing(_ obj: Notification) {
        if let editedTextField = obj.object as? NSTextField {
            
            // Only change the last edited text field value if it matches the last keystrokes otherwise it changes with every tab amongst the fields
            
            if lastFieldValue == editedTextField.stringValue {
                lastEditedField = String(describing: editedTextField.identifier!.rawValue)
                print(lastEditedField)
//                if let lastFieldValueDouble = Double(lastFieldValue) {
//                    editedTextField.stringValue = lastFieldValueDouble.currency
//                }

            }
        }
    }
    
    //MARK: Calculation Functions
    
    func calculate(withField editedTextField: NSTextField) {
        var cost : Double? = Double(costField.stringValue)
        var margin : Double? = Double(marginField.stringValue)
        var revenue : Double? = Double(revenueField.stringValue)
        var profit : Double? = Double(profitField.stringValue)
        
        switch (lastEditedField, editedTextField.identifier!.rawValue) {
        case ("cost", "margin"), ("margin", "cost"):
            guard let cost = cost, let margin = margin else {
                revenueField.stringValue = ""
                profitField.stringValue = ""
                return
            }

            revenue = cost / (1 - (margin / 100))
            
            if let revenue = revenue {
                revenueField.stringValue = String(revenue)
                profit = revenue - cost
                if let profit = profit {
                    profitField.stringValue = String(profit)
                }
            }

        case ("cost", "revenue"), ("revenue", "cost"):
            guard let cost = cost, let revenue = revenue else {
                marginField.stringValue = ""
                profitField.stringValue = ""
                return
            }
            
            margin = 100 * (revenue - cost) / revenue
            
            if let margin = margin {
                marginField.stringValue = String(margin)
                profit = revenue - cost
                if let profit = profit {
                    profitField.stringValue = String(profit)
                }
            }
            
        case ("cost", "profit"), ("profit", "cost"):
            guard let cost = cost, let profit = profit else {
                marginField.stringValue = ""
                revenueField.stringValue = ""
                return
            }
            
            revenue = cost + profit
       
            if let revenue = revenue {
                revenueField.stringValue = String(revenue)
                margin = 100 * (revenue - cost) / revenue
                if let margin = margin {
                    marginField.stringValue = String(margin)
                }
            }
            
        case ("margin", "revenue"), ("revenue", "margin"):
            guard let margin = margin, let revenue = revenue else {
                costField.stringValue = ""
                profitField.stringValue = ""
                return
            }
            
            cost = revenue - (margin * revenue / 100)
            
            if let cost = cost {
                costField.stringValue = String(cost)
                profit = revenue - cost
                if let profit = profit {
                    profitField.stringValue = String(profit)
                }
            }
            
        case ("margin", "profit"), ("profit", "margin"):
            guard let margin = margin, let profit = profit else {
                costField.stringValue = ""
                revenueField.stringValue = ""
                return
            }
            
            revenue = 100 * profit / margin
            
            if let revenue = revenue {
                revenueField.stringValue = String(revenue)
                cost = revenue - profit
                if let cost = cost {
                    costField.stringValue = String(cost)
                }
            }
        case ("revenue", "profit"), ("profit", "revenue"):
            guard let revenue = revenue, let profit = profit else {
                costField.stringValue = ""
                marginField.stringValue = ""
                return
            }
            
            cost = revenue - profit
            
            if let cost = cost {
                costField.stringValue = String(cost)
                margin = 100 * (revenue - cost) / revenue
                if let margin = margin {
                    marginField.stringValue = String(margin)
                }
            }
        default:
            print("Could not find last edited field")
        }

    }
    
    //MARK: Formatting Functions
    
    func replaceWithNumbers(withField editedTextField : NSTextField) {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        let range = editedTextField.stringValue.rangeOfCharacter(from: invalidCharacters)
        if range == nil {
            print(editedTextField.identifier!.rawValue, editedTextField.stringValue)
        } else {
            editedTextField.stringValue.remove(at: editedTextField.stringValue.index(before: editedTextField.stringValue.endIndex))
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

//TODO: Number Formatting and De-Formatting Extensions

//extension NumberFormatter {
//    convenience init(style: Style) {
//        self.init()
//        self.locale = Locale(identifier: "en_GB")
//        numberStyle = style
//    }
//}
//
//extension Formatter {
//    static let currency = NumberFormatter(style: .currency)
//}
//
//
//extension Numeric {
//    var currency: String {
//        return Formatter.currency.string(for: self) ?? ""
//    }
//}

