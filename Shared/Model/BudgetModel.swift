//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI


struct BudgetModel: Hashable, Identifiable {

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



class GetBudgets: ObservableObject {
    @Published var items = [BudgetModel]()

    init() {
        self.items = [
        
        ]
    }
}


class GetMonthlyBudgets: ObservableObject {
    @Published var items = [BudgetModel]()

    init() {
        self.items = [
           
        ]
    }
}
