//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI
import CoreData


struct StockModel: Hashable, Identifiable {

     var id: UUID
     var name: String
     var symbol: String
     var amount: Double
    var avgPurchase: Double
    var price: Double
    var accountId: UUID
    var notificated: Bool
    var notificationPriceUp: Double
    var notificationPriceDown: Double


    
    init() {
        self.id = UUID()
        self.name = ""
        self.symbol = ""
        self.amount = 0
        self.avgPurchase = 0
        self.price = 0
        self.accountId = UUID()
        self.notificationPriceUp = 0
        self.notificationPriceDown = 0
        self.notificated = false
        
    }
}

