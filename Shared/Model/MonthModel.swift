//
//  MonthModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/27/21.
//

import SwiftUI


struct MonthModel: Hashable, Identifiable {

     var id: UUID
    var name: String
     var initialAmount: Double
    var finalAmount: Double
    var month: Int32
    var year: Int32
    var timestamp: Date
    var items = [TransactionModel]()

    
    init() {
        self.id = UUID()
        self.name = ""
        self.initialAmount = 0
        self.finalAmount = 0
        self.month = 0
        self.year = 0
        self.timestamp = Date()
        self.items = [TransactionModel]()
    }
}




class GetMonths: ObservableObject {
    @Published var items = [MonthModel]()

    init() {
        self.items = [
            
        ]
    }
}
