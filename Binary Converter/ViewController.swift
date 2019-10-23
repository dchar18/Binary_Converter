//
//  ViewController.swift
//  Binary Converter
//
//  Created by Damian Charczuk on 12/30/18.
//  Copyright © 2018 Damian Charczuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var inputTextbox: UITextField!
    @IBOutlet weak var converterSegmentControl: UISegmentedControl!
    @IBOutlet weak var convertButton: UIButton!
    
    @IBOutlet weak var bitsLabel: UILabel!
    @IBOutlet weak var bitStepper: UIStepper!
    
    
    //used to differentiate between which way the user wants to convert
    //0 by default, only changed when the user chooses the other option
    var conversionMode = 0
    var input = 0
    var num_bits = 4
    
    //initial setup on startup
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        numberLabel.text = ""
//        convertButton.isEnabled = false
        convertButton.isEnabled = true
        numberLabel.adjustsFontSizeToFitWidth = true
        bitsLabel.text = "4"
        
        bitStepper.wraps = true
        bitStepper.autorepeat = true
        bitStepper.maximumValue = 20
    }
    
    //actions taken when segment control is interacted with
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        if converterSegmentControl.isEnabledForSegment(at: 1){ // bin to dec
            conversionMode = 1
        }
        else{
            conversionMode = 0
        }
    }
    
    @IBAction func bitStepper(_ sender: UIStepper) {
        num_bits = Int(sender.value)
        bitsLabel.text = Int(sender.value).description
    }
    
    
    //actions taken when user types input into textbox
    @IBAction func onInputGiven(_ sender: UITextField) {
        convertButton.isEnabled = true
    }
    
    @IBAction func onButtonPressed(_ sender: UIButton) {
        if(inputTextbox.text != ""){
            input = Int(inputTextbox.text!)!
        }
        else{
            numberLabel.text = "No input given. Please enter a number"
        }
        
        if(converterSegmentControl.selectedSegmentIndex == 0){
            decimalToBinary(input: input)
        }
        else if(converterSegmentControl.selectedSegmentIndex == 1){
            binaryToDecimal(input: input)
        }
    }
    
    //function to convert from decimal to binary, returns an integer
    func decimalToBinary(input : Int) -> Void{
        if(input > 2147483647){ // input is larger than 32-bit binary number
            numberLabel.text = "Input too large"
            return
        }
        if input < 0 {
            numberLabel.text = "Invalid input"
            return
        }
        if input == 0 {
            numberLabel.text = "0"
            return
        }
        if input == 1 {
            numberLabel.text = "1"
            return
        }
        
        //put conversion code here
        var decimal = input
//        var bit = 0
//        var bit_val = power(base: 2, power: bit)
        
//        while(bit_val <= decimal){
//            bit += 1
//            bit_val *= 2
//        }
        
//        var counter = bit
        var counter = num_bits
        var binary = ""
        while(counter > 0){
            if(decimal - power(base: 2, power: counter-1) >= 0){
                decimal -= power(base: 2, power: counter-1)
                binary.append("1")
            }
            else{
                binary.append("0")
            }
            counter -= 1
        }
        numberLabel.text = binary
    }
    
    func power(base : Int, power : Int) -> Int{
        var result = 1
        if power <= 0{
            return 1
        }
        else {
            for _ in 1...power{
                result *= 2
            }
        }
        return result
    }
    
    //function to convert from binary to decimal, returns an integer
    func binaryToDecimal(input : Int) -> Void{
        //put conversion code here
        if input == 0{
            numberLabel.text = "0"
            return
        }
        if input == 1{
            numberLabel.text = "1"
            return
        }
        
        var temp = input // copy of the input binary number
        var bits = 0
        var decimal = 0
        while(temp / 10 > 0){
            bits += 1
            temp /= 10
        }
        if bits == 0{
            numberLabel.text = "Please enter a number"
            return
        }
        temp = input
        
        var counter = 0 // keeps track of position of the next digit
        var bit = 0 // current bit being considered
        while(counter <= bits){
            if temp % 10 > 1{
                numberLabel.text = "Please enter a valid binary number"
                numberLabel.adjustsFontSizeToFitWidth = true
                return
            }
            bit = temp % 2
            if bit == 0 {
                counter += 1
                temp /= 10 // get rid of the last digit
                continue
            }
            else if bit == 1 {
                var val = 1
                if(counter > 0){
                    for _ in 1...counter{
                        val *= 2
                    }
                }
                decimal += val
                counter += 1
                temp /= 10 // get rid of the last digit
            }
            else {
                numberLabel.text = "Please enter a valid binary number"
                return
            }
        }
        numberLabel.text = String(decimal)
    }
}

