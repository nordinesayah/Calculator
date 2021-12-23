//
//  ViewController.swift
//  calculator
//
//  Created by Nordine Sayah on 14/09/2018.
//  Copyright © 2018 Nordine Sayah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var resultLbl: UILabel!
    private var middleTyping = false
    private var cumulate = 0
    private var currentSign = ""
    private var tmp = false
    private var nbAfterSign = false
    private var crash = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override var prefersStatusBarHidden: Bool {
        // Cache status Bar
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func numbers(_ sender: UIButton) {
        let txtDisplay = resultLbl.text
        
        if let nbTxt = sender.titleLabel?.text {
            print(nbTxt)
            resultLbl.text = nbTxt
            if middleTyping {
                resultLbl.text = txtDisplay! + nbTxt
            } else {
                resultLbl.text = nbTxt
                middleTyping = true
            }
            nbAfterSign = true
        }
    }
    
    @IBAction func operand(_ sender: UIButton) {
        if let operandTxt = sender.titleLabel?.text {
            print(operandTxt)
            if middleTyping {
                middleTyping = false
            }
            
            switch operandTxt {
            case "AC":
                debug(toDisplay: "0")
            case "NEG":
                if let nbNeg = Int(resultLbl.text!) {
                    resultLbl.text = String(-(nbNeg))
                }
                operation(sign: currentSign)
                if (crash) {
                    crash = false
                    return
                }
                if let nbNeg = Int(resultLbl.text!), cumulate == 0 {
                    cumulate = nbNeg
                    resultLbl.text = String(cumulate)
                    return
                }
                resultLbl.text = String(cumulate)
            case "=":
                nbAfterSign = true
                operation(sign: currentSign)
                tmp = false
            default:
                operation(sign: currentSign)
                currentSign = operandTxt
            }
        }
    }
    
    func operation(sign: String) {
        if let nbDisplay = Int(resultLbl.text!), tmp, nbAfterSign {
            switch sign {
            case "%":
                let value = cumulate.remainderReportingOverflow(dividingBy: nbDisplay)
                if (value.overflow) {
                    debug(toDisplay: "Overflow")
                    return
                } else {
                    cumulate %= nbDisplay
                }
            case "+":
                let value = cumulate.addingReportingOverflow(nbDisplay)
                if (value.overflow) {
                    debug(toDisplay: "Overflow")
                    return
                } else {
                    cumulate += nbDisplay
                }
            case "-":
                let value = cumulate.subtractingReportingOverflow(nbDisplay)
                if (value.overflow) {
                    debug(toDisplay: "Overflow")
                    return
                } else {
                    cumulate -= nbDisplay
                }
            case "×":
                let value = cumulate.multipliedReportingOverflow(by: nbDisplay)
                if (value.overflow) {
                    debug(toDisplay: "Overflow")
                    return
                } else {
                    cumulate *= nbDisplay
                }
            case "÷":
                if (nbDisplay != 0) {
                    let value = cumulate.dividedReportingOverflow(by: nbDisplay)
                    if (value.overflow) {
                        debug(toDisplay: "Overflow")
                        return
                    } else {
                        cumulate /= nbDisplay
                    }
                } else {
                    debug(toDisplay: "Error")
                    return
                }
            default:
                break
            }
            resultLbl.text = String(cumulate)
        } else {
            if let nbDisplay = Int(resultLbl.text!) {
                cumulate = nbDisplay
            } else {
                debug(toDisplay: "Overflow")
            }
            tmp = true
        }
        nbAfterSign = false
    }
    
    func debug(toDisplay: String) {
        if (toDisplay == "Overflow") {
            crash =  true
        }
        resultLbl.text = toDisplay
        cumulate = 0
        currentSign = ""
        tmp = false
    }
}



