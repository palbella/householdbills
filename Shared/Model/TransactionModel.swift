//
//  TransactionModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/29/21.
//

import Foundation

struct TransactionModel: Hashable, Identifiable {

    var id: UUID
     var name: String
     var symbol: String
    var currency: String
    var account: String
     var amount: Double
    var initialAmount: Double
    var type: String
    var destinationId: UUID
    var destination: String
    var iconContent: String
    var iconColor: String
    var timestamp: Date?
    var category: Int32
    var month: Int32
    

    
    init() {
        self.id = UUID()
        self.name = ""
        self.symbol = ""
        self.currency = ""
        self.account = ""
        self.amount = 0
        self.type = ""
        self.destination = ""
        self.destinationId = UUID()
        self.iconContent = ""
        self.iconColor = ""
        self.timestamp = Date()
        self.category = 0
        self.month = 0
        self.initialAmount = 0
    }
    
}




class GetTransactions: ObservableObject {
    @Published var months = [MonthModel]()
    

    init() {
        self.months = [
        ]
    }
}
