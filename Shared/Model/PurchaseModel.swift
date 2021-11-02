//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI


struct PurchaseModel: Hashable, Identifiable {

     var id: UUID
     var name: String
     var symbol: String
    var currency: String
     var amount: Double
    var iconContent: String
    var iconColor: String


    
    init() {
        self.id = UUID()
        self.name = ""
        self.symbol = ""
        self.currency = ""
        self.amount = 0
        self.iconContent = ""
        self.iconColor = ""
    }
}



class GetPurchases: ObservableObject {
    @Published var items = [PurchaseModel]()

    init() {
        self.items = [
        
        ]
    }
}


class GetMonthlyPurchases: ObservableObject {
    @Published var items = [PurchaseModel]()

    init() {
        self.items = [
           
        ]
    }
}
