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
    var purchaseId: UUID
    var purchased: Bool


    
    init() {
        self.id = UUID()
        self.name = ""
        self.purchaseId = UUID()
        self.purchased = false
        self.price = 0
     
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
