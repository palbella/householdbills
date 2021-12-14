//
//  Service.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/20/21.
//

import SwiftUI
import CoreData




struct GetPasswordEncription {

    
    init() {

    }
    
    
    
    
    func Desentrypt(pin: String, password: String) -> String {
        
   
        //var characters = Array(password)
        let hexaCharacters = password.inserting(separator: " ", every: 2)
        
        let pinCode = Int(pin)
        
        if pinCode == nil || pinCode == 0 || pinCode! > 9999999999 {
            return "Incorrect PIN"
        }

        var result = ""

        //33 to 126 = 93
        
        var divcode = pinCode! / 93
        
        divcode = abs(divcode)
        
        let code = Int(pin)! - (divcode * 93) - 1
        
        let array = hexaCharacters.split{$0 == " "}.map(String.init)

        for hexElement in array {
            
            var hexElementA = String(hexElement.suffix(1)).uppercased()
            var hexElementB = String(hexElement.prefix(1)).uppercased()
            
            for _ in 0...code {
                hexElementA = desencryptCode(char: hexElementA)
                hexElementB = desencryptCode(char: hexElementB)
            }
            
            let hexElement = String(hexElementA + hexElementB)
            
            let code = Int(strtoul(hexElement, nil, 16))
            
            
            result = result +  String(UnicodeScalar(code)!)
        }
        

        result = Data(base64Encoded: result, options: Data.Base64DecodingOptions(rawValue: 0))
            .map({ String(data: $0, encoding: .utf8)! })!
        
          return result
        }
    
    
    func Entrypt(pin: String, password: String) -> String {
        
        let utf8str = password.data(using: .utf8)
        let base64Encoded = String((utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)))!)
        
        //var characters = Array(password)
        let characters = base64Encoded.map(String.init)

        var result = ""

        //33 to 126 = 93
        
        var divcode = Int(pin)! / 93
        
        divcode = abs(divcode)
        
        let code = Int(pin)! - (divcode * 93) - 1

        for char in characters{
            let isAscii = char.data(using: .ascii)
            
            if(isAscii == nil) {
                return "Err: Character Not Supported"
            }
            
            var hexElement = char.data(using: .ascii)!.hexString
            var hexElementA = String(hexElement.suffix(1)).uppercased()
            var hexElementB = String(hexElement.prefix(1)).uppercased()
            
            for _ in 0...code {
                hexElementA = encryptCode(char: hexElementA)
                hexElementB = encryptCode(char: hexElementB)
            }
            
            hexElement = String(hexElementA + hexElementB)
            
            result = result + hexElement
        }
        
          return result
        }
    
    func encryptCode (char: String) -> String {
        
        var result = ""
        
        if(Int(char) != nil) {
            if (Int(char) == 9) {
                result = "A"
            } else {
                result = String(Int(char)! + 1)
            }
        } else {
            switch char {
            case "A":
                result = "B"
            case "B":
                result = "C"
            case "C":
                result = "D"
            case "D":
                result = "E"
            case "E":
                result = "F"
            case "F":
                result = "0"
            default:
                result = ""
            }
        }
        
        return result
    }
    
    func desencryptCode (char: String) -> String {
        
        var result = ""
        
        if(Int(char) != nil) {
            if (Int(char) == 0) {
                result = "F"
            } else {
                result = String(Int(char)! - 1)
            }
        } else {
            switch char {
            case "A":
                result = "9"
            case "B":
                result = "A"
            case "C":
                result = "B"
            case "D":
                result = "C"
            case "E":
                result = "D"
            case "F":
                result = "E"
            default:
                result = ""
            }
        }
        
        return result
    }
    
   

}


