//
//  PurchaseTask.swift
//  HouseholdBills
//
//  Created by Pablo Albella on 1/7/22.
//

import Foundation
import StoreKit
import CoreData
import SwiftUI


class ExportImportTask: ObservableObject {
    
    
    init() {
    
    }
    
    func exportData(csv: String) -> String {
        
        var file = csv
        
        file = "No, Name, email, phone\n" // These are the columns titles
            let number = 0
        let name = "aaa"
        let email = "ffff"
            // 1st Step
        
        file.append("\(number), \(name), \(email), \(email) \n")
        file.append("\(number), \(name), \(email), \(email) \n")
     
        return file
    }
    
    func importData(csv: Data) -> String {
        
        var file = csv
     
        return "file"
    }
}
