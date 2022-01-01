//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI


struct AccountModel: Hashable, Identifiable {

     var id: UUID
     var name: String
     var symbol: String
    var currency: String
     var amount: Double
    var iconContent: String
    var iconColor: String
    var type: String
    var ignoreGoal: Bool
    var group: String

    
    init() {
        self.id = UUID()
        self.name = ""
        self.symbol = ""
        self.currency = ""
        self.amount = 0
        self.iconContent = ""
        self.iconColor = ""
        self.type = ""
        self.ignoreGoal = false
        self.group = ""
    }
}



class GetAccounts: ObservableObject {
    @Published var items = [AccountModel]()

    init() {
        self.items = [

        ]
    }
}
