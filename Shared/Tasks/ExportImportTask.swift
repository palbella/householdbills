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
        
        file = "[Account], , , , , , , , , , , , , , , , , , , \n"
        
        var fields = CSVFields()
       
        let accounts = AccountData().fetch()
        for i in 0..<accounts.count {
            fields = AccountData().stringToEntityMap(account: accounts[i])
            
            file.append("\(fields.field1), \(fields.field2), \(fields.field3), \(fields.field4), \(fields.field5), \(fields.field6), \(fields.field7), \(fields.field8), \(fields.field9), \(fields.field10),\(fields.field11), \(fields.field12), \(fields.field13), \(fields.field14), \(fields.field15), \(fields.field16), \(fields.field17), \(fields.field18), \(fields.field19), \(fields.field20) \n")
        }
        
        file.append("[Cryptocurrency], , , , , , , , , , , , , , , , , , , \n")
       
        let cryptos = CryptocurrencyData().fetch()
        for i in 0..<cryptos.count {
            fields = CryptocurrencyData().stringToEntityMap(crypto: cryptos[i])
            
            file.append("\(fields.field1), \(fields.field2), \(fields.field3), \(fields.field4), \(fields.field5), \(fields.field6), \(fields.field7), \(fields.field8), \(fields.field9), \(fields.field10),\(fields.field11), \(fields.field12), \(fields.field13), \(fields.field14), \(fields.field15), \(fields.field16), \(fields.field17), \(fields.field18), \(fields.field19), \(fields.field20) \n")
        }
        
        file.append("[Stock], , , , , , , , , , , , , , , , , , , \n")
       
        let stocks = StockData().fetch()
        for i in 0..<stocks.count {
            fields = StockData().stringToEntityMap(stock: stocks[i])
            
            file.append("\(fields.field1), \(fields.field2), \(fields.field3), \(fields.field4), \(fields.field5), \(fields.field6), \(fields.field7), \(fields.field8), \(fields.field9), \(fields.field10),\(fields.field11), \(fields.field12), \(fields.field13), \(fields.field14), \(fields.field15), \(fields.field16), \(fields.field17), \(fields.field18), \(fields.field19), \(fields.field20) \n")
        }
        
        file.append("[Goal], , , , , , , , , , , , , , , , , , , \n")
       
        let goals = GoalData().fetch()
        for i in 0..<goals.count {
            fields = GoalData().stringToEntityMap(goal: goals[i])
            
            file.append("\(fields.field1), \(fields.field2), \(fields.field3), \(fields.field4), \(fields.field5), \(fields.field6), \(fields.field7), \(fields.field8), \(fields.field9), \(fields.field10),\(fields.field11), \(fields.field12), \(fields.field13), \(fields.field14), \(fields.field15), \(fields.field16), \(fields.field17), \(fields.field18), \(fields.field19), \(fields.field20) \n")
        }
        
        file.append("[Budget], , , , , , , , , , , , , , , , , , , \n")
       
        let budgets = BudgetData().fetch()
        for i in 0..<budgets.count {
            fields = BudgetData().stringToEntityMap(budget: budgets[i])
            
            file.append("\(fields.field1), \(fields.field2), \(fields.field3), \(fields.field4), \(fields.field5), \(fields.field6), \(fields.field7), \(fields.field8), \(fields.field9), \(fields.field10),\(fields.field11), \(fields.field12), \(fields.field13), \(fields.field14), \(fields.field15), \(fields.field16), \(fields.field17), \(fields.field18), \(fields.field19), \(fields.field20) \n")
        }
        
        file.append("[Payment], , , , , , , , , , , , , , , , , , , \n")
        
        let payments = PaymentData().fetch()
        for i in 0..<payments.count {
            fields = PaymentData().stringToEntityMap(payment: payments[i])
            
            file.append("\(fields.field1), \(fields.field2), \(fields.field3), \(fields.field4), \(fields.field5), \(fields.field6), \(fields.field7), \(fields.field8), \(fields.field9), \(fields.field10),\(fields.field11), \(fields.field12), \(fields.field13), \(fields.field14), \(fields.field15), \(fields.field16), \(fields.field17), \(fields.field18), \(fields.field19), \(fields.field20) \n")
        }
        
        file.append("[MonthlyBudget], , , , , , , , , , , , , , , , , , , \n")
       
        let monthlyBudgets = MonthlyBudgetData().fetch()
        for i in 0..<monthlyBudgets.count {
            fields = MonthlyBudgetData().stringToEntityMap(budget: monthlyBudgets[i])
            
            file.append("\(fields.field1), \(fields.field2), \(fields.field3), \(fields.field4), \(fields.field5), \(fields.field6), \(fields.field7), \(fields.field8), \(fields.field9), \(fields.field10),\(fields.field11), \(fields.field12), \(fields.field13), \(fields.field14), \(fields.field15), \(fields.field16), \(fields.field17), \(fields.field18), \(fields.field19), \(fields.field20) \n")
        }
        
        file.append("[MonthlyPayment], , , , , , , , , , , , , , , , , , , \n")
        
        let monthlyPayments = MonthlyPaymentData().fetch()
        for i in 0..<monthlyPayments.count {
            fields = MonthlyPaymentData().stringToEntityMap(payment: monthlyPayments[i])
            
            file.append("\(fields.field1), \(fields.field2), \(fields.field3), \(fields.field4), \(fields.field5), \(fields.field6), \(fields.field7), \(fields.field8), \(fields.field9), \(fields.field10),\(fields.field11), \(fields.field12), \(fields.field13), \(fields.field14), \(fields.field15), \(fields.field16), \(fields.field17), \(fields.field18), \(fields.field19), \(fields.field20) \n")
        }
        
        file.append("[Password], , , , , , , , , , , , , , , , , , , \n")
       
        let passwords = PasswordData().fetch()
        for i in 0..<passwords.count {
            fields = PasswordData().stringToEntityMap(password: passwords[i])
            
            file.append("\(fields.field1), \(fields.field2), \(fields.field3), \(fields.field4), \(fields.field5), \(fields.field6), \(fields.field7), \(fields.field8), \(fields.field9), \(fields.field10),\(fields.field11), \(fields.field12), \(fields.field13), \(fields.field14), \(fields.field15), \(fields.field16), \(fields.field17), \(fields.field18), \(fields.field19), \(fields.field20) \n")
        }
     
        return file
    }
    
    func importData(url: URL) {
        
        
        do {
                   var contents = try String(contentsOf: url, encoding: .utf8)
                   contents = cleanRows(file: contents)
            let records = csv(data: contents)
            
            var entity = ""
            var isEntity = false
            
            for i in 0..<records.count {
                let line = records[i]
                
                if(line[0].contains("[Account]")) {
                    entity = "Account"
                    isEntity = true
                }
                if(line[0].contains("[Goal]")) {
                    entity = "Goal"
                    isEntity = true
                }
                if(line[0].contains("[Budget]")) {
                    entity = "Budget"
                    isEntity = true
                }
                if(line[0].contains("[Payment]")) {
                    entity = "Payment"
                    isEntity = true
                }
                if(line[0].contains("[Password]")) {
                    entity = "Password"
                    isEntity = true
                }
                if(line[0].contains("[MonthlyBudget]")) {
                    entity = "Budget"
                    isEntity = true
                }
                if(line[0].contains("[MonthlyPayment]")) {
                    entity = "Payment"
                    isEntity = true
                }
                if(line[0].contains("[Stock]")) {
                    entity = "Stock"
                    isEntity = true
                }
                if(line[0].contains("[Cryptocurrency]")) {
                    entity = "Cryptocurrency"
                    isEntity = true
                }
                
                if( isEntity != true) {
                    importLine(line: line[0], entity: entity)
                } else {
                    isEntity = false
                }
                
            }
          
               } catch {
                   print("File Read Error for file \(url)")
                   
               }
     
     
    }
    
    func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
    
    func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ";")
            result.append(columns)
        }
        return result
    }
    
    
    func importLine(line: String, entity: String) {
        print(line)
    }
    
}


struct CSVFields: Hashable {

     
    var field1: String
    var field2: String
    var field3: String
    var field4: String
    var field5: String
    var field6: String
    var field7: String
    var field8: String
    var field9: String
    var field10: String
    var field11: String
    var field12: String
    var field13: String
    var field14: String
    var field15: String
    var field16: String
    var field17: String
    var field18: String
    var field19: String
    var field20: String
    
    init() {
        self.field1 = ""
        self.field2 = ""
        self.field3 = ""
        self.field4 = ""
        self.field5 = ""
        self.field6 = ""
        self.field7 = ""
        self.field8 = ""
        self.field9 = ""
        self.field10 = ""
        self.field11 = ""
        self.field12 = ""
        self.field13 = ""
        self.field14 = ""
        self.field15 = ""
        self.field16 = ""
        self.field17 = ""
        self.field18 = ""
        self.field19 = ""
        self.field20 = ""
    }
}
