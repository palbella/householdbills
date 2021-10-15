//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI


struct PaymentModel: Hashable, Identifiable {

     var id: UUID
     var name: String
     var symbol: String
    var currency: String
     var amount: Double
    var isGoal: Bool
    var isPaid: Bool
    var goalId: UUID?
    var iconContent: String
    var iconColor: String
    var account: UUID
    var category: Int32
    var order: Int32
    var priority: Int32
    var notificationDay: Int32
    var notificated: Bool
    

    
    init() {
        self.id = UUID()
        self.name = ""
        self.symbol = ""
        self.currency = ""
        self.amount = 0
        self.isGoal = false
        self.isPaid = false
        self.goalId = nil
        self.iconContent = ""
        self.iconColor = ""
        self.account = UUID()
        self.category = 0
        self.order = 0
        self.priority = 0
        self.notificated = false
        self.notificationDay = 0
    }
}



class GetPayments: ObservableObject {
    @Published var items = [PaymentModel]()

    init() {
        self.items = [
           
        ]
    }
}

class GetMontlyPayments: ObservableObject {
    @Published var items = [PaymentModel]()

    init() {
        self.items = [
           
        ]
    }
}
