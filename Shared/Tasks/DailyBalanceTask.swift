//
//  DailyBalanceTask.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 10/7/21.
//

import Foundation
import SwiftUI
import CoreData




struct DailyBalanceTask {
    @State var viewContext: NSManagedObjectContext
    @State var settings: UserSettings
    
 
    
    init(viewContext: NSManagedObjectContext, settings: UserSettings) {
        self.viewContext = viewContext
        self.settings = settings
    }
    
    func run() {
       
        do {

            
            let request: NSFetchRequest<DailyBalance> = DailyBalance.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            let records = try viewContext.fetch(request)

        
        if(records.count > 0 ) {
        var last = records[0].date!
            let today = removeTimeStamp(fromDate: Date())
        
        while last <= today {
            var dayComponent    = DateComponents()
            dayComponent.day    = 1 // For removing one day (yesterday): -1
            let theCalendar     = Calendar.current
            let nextDate        = theCalendar.date(byAdding: dayComponent, to: last)
            
            let newDaily = DailyBalance(context: viewContext)
            newDaily.id = UUID()
            newDaily.date = nextDate
            newDaily.balance = getBalance()
            
            SaveContext()
            
            last = nextDate!
        }
        } else {
            let newDaily = DailyBalance(context: viewContext)
            newDaily.id = UUID()
            newDaily.date = Date()
            newDaily.balance = getBalance()
            
            SaveContext()
        }
        } catch {
            
        }
        
    }
    
    func getBalance() -> Double {
        var balance: Double = 0
        let currencies = GetCurrencies()
        let fetchCurrencies = CurrencyData()
        currencies.items = fetchCurrencies.fetch()
        
        
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()

        do {
            let savedAccounts =  try viewContext.fetch(fetchRequest)

                            for index in 0..<savedAccounts.count {
                              
                                let amount: Double = currencies.convert(currencyFrom: savedAccounts[index].currency!, currencyTo: settings.currency, value: savedAccounts[index].amount)
                                
                                balance = balance + amount
                              
                             }
            

        } catch {

        }
        
        return balance
    }
    
    private func SaveContext () {
    do {

  try viewContext.save()
        

        }
                            
    
    catch {
      
    }
    }
    
   
}
