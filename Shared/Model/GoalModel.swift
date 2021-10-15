//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI


struct GoalModel: Hashable, Identifiable {

     var id: UUID
     var name: String
     var symbol: String
    var currency: String
     var amount: Double
    var target: Double
    var iconContent: String
    var iconColor: String
    var planning: [GoalModel]
    var planningMonth: String
    
    init() {
        self.id = UUID()
        self.name = ""
        self.symbol = ""
        self.currency = ""
        self.amount = 0
        self.target = 0
        self.iconContent = ""
        self.iconColor = ""
        self.planning = []
        self.planningMonth = ""
    }
}



class GetGoals: ObservableObject {
    @Published var items = [GoalModel]()

    init() {
        self.items = [
        ]
    }
}
