//
//  Stock.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/20/21.
//

import SwiftUI
import CoreData




struct GetMarketStocks {
    @State var viewContext: NSManagedObjectContext
    
    let request: NSFetchRequest<Stock> = Stock.fetchRequest()
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        
    }
    
    func run() {
        saveTotalAccounts ()
    }
    
 
    func saveTotalAccounts () {
        
        let accountRequest: NSFetchRequest<Account> = Account.fetchRequest()
        let stockRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
        
        do {
 
            let savedAccounts = try  viewContext.fetch(accountRequest)
           
            
            for i in 0..<savedAccounts.count {
                if(savedAccounts[i].type == "stock") {
                var total: Double = 0
                
                    stockRequest.predicate = NSPredicate(format: "accountId = %@", savedAccounts[i].id! as CVarArg)
                let savedStocks = try  viewContext.fetch(stockRequest)
                
                for index in 0..<savedStocks.count {
                    
                    total = total + (savedStocks[index].price * savedStocks[index].amount)
                    
            }
                savedAccounts[i].amount = total
                SaveContext()
            }
            }
            
        } catch {
            print(error)
        }
        
    }
    
    private func SaveContext () {
    do {

  try viewContext.save()
        

        }
                            
    
    catch {
      
    }
    }
}


