//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI


struct PurchaseItemModel: Hashable, Identifiable {

     var id: UUID
     var name: String
     var price: Double
    var amount: Double
    var purchaseId: UUID
    var purchased: Bool
    var unit: String
    var lastone: Bool
    var monthlyId: UUID?
    
    init() {
        self.id = UUID()
        self.name = ""
        self.purchaseId = UUID()
        self.purchased = false
        self.price = 0
        self.amount = 0
        self.unit = ""
        self.lastone = false
        self.monthlyId = nil
    }
}



class GetPurchaseItems: ObservableObject {
    @Published var items = [PurchaseItemModel]()

    init() {
        self.items = [
        
        ]
    }
}


class GetMonthlyPurchaseItems: ObservableObject {
    @Published var items = [PurchaseItemModel]()

    init() {
        self.items = [
           
        ]
    }
}
