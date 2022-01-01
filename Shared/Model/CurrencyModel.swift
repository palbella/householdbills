//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI


struct CurrencyModel: Hashable, Identifiable {

     var id: Int
     var name: String
     var symbol: String
    var code: String
    var rate: Double
    var update: Bool
    var selected: Bool
  
    
    init() {
        self.id = 0
        self.name = ""
        self.symbol = ""
        self.code = ""
        self.rate = 0
        self.update = false
        self.selected = false
    }
}



class GetCurrencies: ObservableObject {
    @Published var items = [CurrencyModel]()

    init() {
        self.items = []
    }
    

    func getSymbol (currency: String) -> String {
        for i in 0..<items.count {
            if(items[i].code == currency) {
                return items[i].symbol
            }
        }

        return ""
    }
    
    func getRate (currency: String) -> Double {
        for i in 0..<items.count {
            if(items[i].code == currency) {
                return items[i].rate
            }
        }

        return 1
    }
    
    func convert (currencyFrom: String, currencyTo: String, value: Double) -> Double {
       
        var amount: Double = 0
        if(currencyFrom == currencyTo) {
            amount = value
        } else {
            print(self.getRate(currency: currencyFrom))
            let temp = value / self.getRate(currency: currencyFrom)
            if(currencyTo == "USD") {
                amount = temp
            } else {
                amount = temp * self.getRate(currency: currencyTo)
            }
        }
        
        return amount
        
    }
}
