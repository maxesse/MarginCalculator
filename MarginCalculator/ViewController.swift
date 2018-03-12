//
//  ViewController.swift
//  MarginCalculator
//
//  Created by Max Sanna on 28/02/2018.
//  Copyright © 2018 Max Sanna. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    
    //MARK: - Outlets and variables initialisation

    @IBOutlet weak var costField: SelfFormattingTextField!
    @IBOutlet weak var marginField: SelfFormattingTextField!
    @IBOutlet weak var revenueField: SelfFormattingTextField!
    @IBOutlet weak var profitField: SelfFormattingTextField!
    

    var lastFieldValue : (String, String) = ("","")
    
    var valuesDictionary : [String : Double] = [:]
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        costField.myDelegate = self
        marginField.myDelegate = self
        revenueField.myDelegate = self
        profitField.myDelegate = self
        
        costField.delegate = self
        marginField.delegate = self
        revenueField.delegate = self
        profitField.delegate = self
        resetDictionary()
        
    }
    
    override func viewWillAppear() {
        // costField.becomeFirstResponder()
    }
    
    //MARK: Calculation Functions
    
    func calculate(withField editedTextField: SelfFormattingTextField) {
        
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
        
        // Update the dictionary
        
        valuesDictionary["cost"] = cost.rounded(toPlaces: 2)
        valuesDictionary["margin"] = margin.rounded(toPlaces: 2)
        valuesDictionary["revenue"] = revenue.rounded(toPlaces: 2)
        valuesDictionary["profit"] = profit.rounded(toPlaces: 2)
    }
    
    //MARK: - Populate Dictionary Functions
    
    func populateDictionary(withField editedTextField : SelfFormattingTextField) {
        if editedTextField.stringValue == "" {
            valuesDictionary[editedTextField.identifier!.rawValue] = 0
        } else {
            valuesDictionary[editedTextField.identifier!.rawValue] = Double(editedTextField.stringValue)
            print(valuesDictionary)
        }

    }
    
    func resetDictionary() {
        valuesDictionary = ["cost" : 0,
                            "margin" : 0,
                            "revenue" : 0,
                            "profit" : 0]
    }
    
    //MARK: - Formatting Functions
    
    func replaceWithNumbers(withField editedTextField : SelfFormattingTextField) {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789.").inverted
        let range = editedTextField.stringValue.rangeOfCharacter(from: invalidCharacters)
        if range == nil {
            // print(editedTextField.identifier!.rawValue, editedTextField.stringValue)
        } else {
            editedTextField.stringValue.remove(at: editedTextField.stringValue.index(before: editedTextField.stringValue.endIndex))
        }
    }
    
    //MARK: - Reset Button
    
    @IBAction func resetButtonPressed(_ sender: NSButton) {
        resetDictionary()
        costField.stringValue = ""
        marginField.stringValue = ""
        revenueField.stringValue = ""
        profitField.stringValue = ""
        costField.currentEditor()
    }
    

}

//MARK: - NSTextFieldDelegate Methods

extension ViewController : NSTextFieldDelegate {
    override func controlTextDidChange(_ obj: Notification) {
        
        if let editedTextField = obj.object as? SelfFormattingTextField {
            populateDictionary(withField: editedTextField)
            replaceWithNumbers(withField: editedTextField)
            lastFieldValue.1 = editedTextField.stringValue
            
            calculate(withField: editedTextField)
            print("Control text just changed! \(editedTextField.stringValue)")
        }
    }
    
    override func controlTextDidEndEditing(_ obj: Notification) {
        if let editedTextField = obj.object as? SelfFormattingTextField {
            
            // Only change the last edited text field value if it matches the last keystrokes otherwise it changes with every tab amongst the fields
            
            if lastFieldValue.1 == editedTextField.stringValue {
                lastFieldValue.0 = editedTextField.identifier!.rawValue
                // print("controlTextDidEndEditing: ",lastFieldValue)
                
                if let lastFieldValueDouble = Double(lastFieldValue.1) {
                    if editedTextField.identifier?.rawValue != "margin" {
                        editedTextField.stringValue = lastFieldValueDouble.currency
                    } else {
                        editedTextField.stringValue = (lastFieldValueDouble / 100).percent
                    }
                }
                
            } else {
                if editedTextField.identifier?.rawValue != "margin" {
                    editedTextField.stringValue = valuesDictionary[editedTextField.identifier!.rawValue]!.currency
                } else {
                    editedTextField.stringValue = (valuesDictionary[editedTextField.identifier!.rawValue]! / 100).percent
                }
            }
            print(lastFieldValue)
        }
    }
}

//MARK: - SelfFormattingTextFieldDelegate Methods

extension ViewController : SelfFormattingTextFieldDelegate {
    func textFieldOnFocus(_ textField: SelfFormattingTextField) {
        print("Field was focused \(textField.identifier!.rawValue)")
        if valuesDictionary[textField.identifier!.rawValue]! != 0 {
            textField.stringValue = String(valuesDictionary[textField.identifier!.rawValue]!)
        }
    }
    
}

//MARK: - Number Formatting Extensions

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

extension Double {
    //Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

