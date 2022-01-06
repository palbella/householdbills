//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI
import CoreData




class CurrencyData: ObservableObject { 
    @Published var items = [CurrencyModel]()
    var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext

    let request: NSFetchRequest<Currency> = Currency.fetchRequest()
  
    
    
    init() {
        self.items = []
    }
    
    func fetch(includeNotSelected: Bool = false) ->  [CurrencyModel]{
        
        if(!includeNotSelected) {
            request.predicate = NSPredicate(format: "selected = true")
        }
        
        do {
        let savedCurrencies = try  viewContext.fetch(request)
        self.items = []
            
            for i in 0..<savedCurrencies.count {
                self.items.append(map(currency: savedCurrencies[i]))
            }
            
        } catch {
            
        }
    
        return self.items
    }
    
    private func map(currency: Currency) -> CurrencyModel
    {
        var currencyModel = CurrencyModel()
        
        currencyModel.id = Int(currency.id)
        currencyModel.name = currency.name ?? ""
        currencyModel.symbol = currency.symbol ?? ""
        currencyModel.code = currency.code ?? ""
        currencyModel.rate = currency.rate
        currencyModel.selected = currency.selected
        currencyModel.update = currency.update

        return currencyModel
    }
    
    func getSymbol (currency: String) -> String {
        for i in 0..<items.count {
            if(items[i].code == currency) {
                return items[i].symbol
            }
        }
        
        return ""
    }
    
    
    func currencyUpdate() {
        
        do {
        let savedCurrencies = try  viewContext.fetch(request)
        self.items = []
            
            for i in 0..<savedCurrencies.count {
                let currency = map(currency: savedCurrencies[i])
                
                let accountRequest: NSFetchRequest<Account> = Account.fetchRequest()
                let savedAccounts = try  viewContext.fetch(accountRequest)
                for i in 0..<savedAccounts.count {
                    if(savedAccounts[i].currency == currency.code) {
                        savedAccounts[i].symbol = currency.symbol
                        SaveContext()
                    }
                }
                
                let paymentRequest: NSFetchRequest<Payment> = Payment.fetchRequest()
                let savedPayments = try  viewContext.fetch(paymentRequest)
                for i in 0..<savedPayments.count {
                    if(savedPayments[i].currency == currency.code) {
                        savedPayments[i].symbol = currency.symbol
                        SaveContext()
                    }
                }
                
                let paymentMRequest: NSFetchRequest<MonthlyPayment> = MonthlyPayment.fetchRequest()
                let savedMPayments = try  viewContext.fetch(paymentMRequest)
                for i in 0..<savedMPayments.count {
                    if(savedMPayments[i].currency == currency.code) {
                        savedMPayments[i].symbol = currency.symbol
                        SaveContext()
                    }
                }
                
                let budgetRequest: NSFetchRequest<Budget> = Budget.fetchRequest()
                let savedBudgets = try  viewContext.fetch(budgetRequest)
                for i in 0..<savedBudgets.count {
                    if(savedBudgets[i].currency == currency.code) {
                        savedBudgets[i].symbol = currency.symbol
                        SaveContext()
                    }
                }
                
                let budgetMRequest: NSFetchRequest<MonthlyBudget> = MonthlyBudget.fetchRequest()
                let savedMBudgets = try  viewContext.fetch(budgetMRequest)
                for i in 0..<savedMBudgets.count {
                    if(savedMBudgets[i].currency == currency.code) {
                        savedMBudgets[i].symbol = currency.symbol
                        SaveContext()
                    }
                }
                
                let purchaseRequest: NSFetchRequest<Purchase> = Purchase.fetchRequest()
                let savedPurchases = try  viewContext.fetch(purchaseRequest)
                for i in 0..<savedPurchases.count {
                    if(savedPurchases[i].currency == currency.code) {
                        savedPurchases[i].symbol = currency.symbol
                        SaveContext()
                    }
                }
                
                let purchaseMRequest: NSFetchRequest<MonthlyPurchase> = MonthlyPurchase.fetchRequest()
                let savedMPurchases = try  viewContext.fetch(purchaseMRequest)
                for i in 0..<savedMPurchases.count {
                    if(savedMPurchases[i].currency == currency.code) {
                        savedMPurchases[i].symbol = currency.symbol
                        SaveContext()
                    }
                }
                
            }
            
        } catch {
            
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
