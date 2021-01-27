//
//  ViewController.swift
//  Calculator
//
//  Created by Jingjing Zhuang on 1/12/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var descript: UILabel!
    var isTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!    //text on the button
        let textInDisplay = display.text!
        if isTyping {
            if digit == "AC" {
                display.text = "0"
                descript.text = "..."
                brain.description = ""
                isTyping = false
            } else if (textInDisplay.contains(".") && digit == ".") {
                display.text = textInDisplay
            } else {
                display.text = textInDisplay + digit
            }
        } else{
            if digit == "." {
                if textInDisplay.contains("."){
                    display.text = textInDisplay
                } else {
                    display.text = textInDisplay + digit
                }
                isTyping = true
            } else if digit == "AC" {
                display.text = "0"
                descript.text = "..."
                brain.description = ""
                isTyping = false
            } else {
                display.text = digit
                isTyping = true
            }
        }
    }
    // covert double to string
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
            descript.text = brain.description
        }
    }
    
    private var brain = CalcBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if isTyping {
            brain.setOperand(displayValue)
            if brain.description.contains("=") {
                brain.description = "..."
            }
            descript.text = brain.description
            isTyping = false
        }
        if let mathSymbol = sender.currentTitle {
            brain.performOperation(mathSymbol)
//            brain.description += mathSymbol
            descript.text = brain.description
        }
        if let result = brain.result {
            displayValue = result
        }
//        descript.text = brain.description
    }
    
}
