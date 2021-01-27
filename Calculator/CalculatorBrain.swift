//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Jingjing Zhuang on 1/17/21.
//

import Foundation

struct CalcBrain {
    
    private var accumulator: Double?
    var resultIsPending = true
    var description = ""
    // operation types
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    // operation dictionary
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "sin" : Operation.unaryOperation(sin),
        "tan" : Operation.unaryOperation(tan),
        "ln" : Operation.unaryOperation(log),
        "+/-" : Operation.unaryOperation({ -$0 }),
        "%" : Operation.unaryOperation({ $0 * 0.01 }),
        "xʸ" : Operation.binaryOperation(pow),
        "+" : Operation.binaryOperation({ $0 + $1 }),
        "−" : Operation.binaryOperation({ $0 - $1 }),
        "×" : Operation.binaryOperation({ $0 * $1 }),
        "÷" : Operation.binaryOperation({ $0 / $1 }),
        "=" : Operation.equals
    ]
    // perform operations: do the calculation or symbol meaning
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
                resultIsPending = true
            case .unaryOperation(let function):
                if accumulator != nil {
                    if description.contains("=") {
                        description = description.replacingOccurrences(of: "=", with: "")
                        description = symbol + "(" + description + ")"
                        resultIsPending = false
                    } else {
                        if accumulator == Double.pi {
                            description += symbol + "(π)"
                        } else if accumulator == M_E {
                            description += symbol + "(e)"
                        } else {
                            description += symbol + "(" + String(accumulator!) + ")"
                        }
                        resultIsPending = true
                    }
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    if description.contains("=") {
                        description = description.replacingOccurrences(of: "=", with: "")
                        if symbol == "xʸ" {
                            description = "(" + description + ")^"
                        } else if symbol == "÷" {
                            description = "(" + description + ")" + symbol
                        } else {
                            description += symbol
                        }
                    } else {
                        if symbol == "xʸ" {
                            if accumulator == Double.pi {
                                description += "π^"
                            } else if accumulator == M_E {
                                description += "e^"
                            } else {
                                description += String(accumulator!) + "^"
                            }
                        } else {
                            if accumulator == Double.pi {
                                description += "π" + symbol
                            } else if accumulator == M_E {
                                description += "e" + symbol
                            } else {
                                description += String(accumulator!) + symbol
                            }
                        }
                    }
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
                resultIsPending = false
            }
        }
        if resultIsPending {
            if !description.contains("...") {
                description += "..."
            }
            if description.contains("...") {
                description = description.replacingOccurrences(of: "...", with: "") + "..."
            }
            if description.contains("=") {
                description = description.replacingOccurrences(of: "=", with: "")
            }
        } else {
            if description.contains("...") && description.count > 3 {
                description = description.replacingOccurrences(of: "...", with: "") + "="
            } else {
                if accumulator != nil {
                    description += "="
                } else {
                    description = "..."
                }
            }
            resultIsPending = true
        }
    }
    // perform binary operation(hits equal): "1 + 2 = 3", "3 x 3 = 9", ...
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            if !description.contains(")...") {
//                print(description)
                if accumulator == Double.pi  {
                    description += "π"
                } else if accumulator == M_E {
                    description += "e"
                } else {
                    description += String(accumulator!)
                }
            }
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    // In the middle of typing: "1 + ", "6 x ", ...
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)    // operand (operator) operand : 1+2
        }
    }
    // mutaing: this method can change the value of the struct
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
}
