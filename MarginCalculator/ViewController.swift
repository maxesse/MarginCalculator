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

    var lastFieldValue : (String, String) = ("","")
    
    var valuesDictionary : [String : Double] = ["cost" : 0,
                                                 "margin" : 0,
                                                 "revenue" : 0,
                                                 "profit" : 0]
    
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
            populateDictionary(withField: editedTextField)
            replaceWithNumbers(withField: editedTextField)
            lastFieldValue.1 = editedTextField.stringValue

            calculate(withField: editedTextField)
        }
    }
    
    override func controlTextDidEndEditing(_ obj: Notification) {
        if let editedTextField = obj.object as? NSTextField {
            
            // Only change the last edited text field value if it matches the last keystrokes otherwise it changes with every tab amongst the fields
            
            if lastFieldValue.1 == editedTextField.stringValue {
                lastFieldValue.0 = editedTextField.identifier!.rawValue
                print("controlTextDidEndEditing: ",lastFieldValue)
                
                if let lastFieldValueDouble = Double(lastFieldValue.1) {
                    if editedTextField.identifier?.rawValue != "margin" {
                        editedTextField.stringValue = lastFieldValueDouble.currency
                    } else {
                        editedTextField.stringValue = (lastFieldValueDouble / 100).percent
                    }
                }

            }
        }
    }
    
    //MARK: Calculation Functions
    
    func calculate(withField editedTextField: NSTextField) {
        
        // We assign the dictionary to variables to make the code below less verbose
        
        var cost = valuesDictionary["cost"] ?? 0
        var margin = valuesDictionary["margin"] ?? 0
        var revenue = valuesDictionary["revenue"] ?? 0
        var profit = valuesDictionary["profit"] ?? 0
        
        switch (lastFieldValue.0, editedTextField.identifier!.rawValue) {
        case ("cost", "margin"), ("margin", "cost"):

            if cost != 0, margin != 0 {
                revenue = cost / (1 - (margin / 100))
                profit = revenue - cost
                revenueField.stringValue = revenue.currency
                profitField.stringValue = profit.currency
            } else {
                revenueField.stringValue = ""
                profitField.stringValue = ""
            }

        case ("cost", "revenue"), ("revenue", "cost"):
            
            if cost != 0, revenue != 0 {
                margin = 100 * (revenue - cost) / revenue
                profit = revenue - cost
                marginField.stringValue = (margin / 100).percent
                profitField.stringValue = profit.currency
            } else {
                marginField.stringValue = ""
                profitField.stringValue = ""
            }

        case ("cost", "profit"), ("profit", "cost"):
            
            if cost != 0, profit != 0 {
                revenue = cost + profit
                margin = 100 * (revenue - cost) / revenue
                revenueField.stringValue = revenue.currency
                marginField.stringValue = (margin / 100).percent
            } else {
                marginField.stringValue = ""
                revenueField.stringValue = ""
            }
            
        case ("margin", "revenue"), ("revenue", "margin"):
            
            if margin != 0, revenue != 0 {
                cost = revenue - (margin * revenue / 100)
                profit = revenue - cost
                costField.stringValue = cost.currency
                profitField.stringValue = profit.currency
            } else {
                costField.stringValue = ""
                profitField.stringValue = ""
            }

        case ("margin", "profit"), ("profit", "margin"):
            
            if margin != 0, profit != 0 {
                revenue = 100 * profit / margin
                cost = revenue - profit
                costField.stringValue = cost.currency
                revenueField.stringValue = revenue.currency
            } else {
                costField.stringValue = ""
                revenueField.stringValue = ""
            }

        case ("revenue", "profit"), ("profit", "revenue"):
            
            if revenue != 0, profit != 0 {
                cost = revenue - profit
                margin = 100 * (revenue - cost) / revenue
                costField.stringValue = cost.currency
                marginField.stringValue = (margin / 100).percent
            } else {
                costField.stringValue = ""
                marginField.stringValue = ""
            }

        default:
            print("Could not find last edited field")
        }

    }
    
    func populateDictionary(withField editedTextField : NSTextField) {
        if editedTextField.stringValue == "" {
            valuesDictionary[editedTextField.identifier!.rawValue] = 0
        } else {
            valuesDictionary[editedTextField.identifier!.rawValue] = Double(editedTextField.stringValue)
            print(valuesDictionary)
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
        costField.becomeFirstResponder()
    }
    

}

//TODO: Number Formatting Extensions

extension NumberFormatter {
    convenience init(style: Style) {
        self.init()
        self.locale = Locale(identifier: "en_GB")
        self.minimumFractionDigits = 0
        self.maximumFractionDigits = 2
        numberStyle = style
    }
}

extension Formatter {
    static let currency = NumberFormatter(style: .currency)
    static let percent = NumberFormatter(style: .percent)
}


extension Numeric {
    var currency: String {
        return Formatter.currency.string(for: self) ?? ""
    }
    
    var percent: String {
        return Formatter.percent.string(for: self) ?? ""
    }
}

