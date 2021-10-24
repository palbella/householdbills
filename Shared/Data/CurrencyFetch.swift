//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI
import CoreData




class FetchCurrencies: ObservableObject { 
    @Published var items = [CurrencyModel]()
   

    let request: NSFetchRequest<Currency> = Currency.fetchRequest()
  
    
    
    init() {
        self.items = []
    }
    
    func fetch(viewContext: NSManagedObjectContext, includeNotSelected: Bool = false) ->  [CurrencyModel]{
        
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
}
