//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI


struct SplitBillsModel: Hashable, Identifiable {

     var id: UUID
     var name: String
    var amount: Double
    var result: Double
    var total: Double
    var selected: Bool
    
    init() {
        self.id = UUID()
        self.name = ""
        self.result = 0
        self.amount = 0
        self.total = 0
        self.selected = false
    }
}



class GetSplitBills: ObservableObject {
    @Published var items = [SplitBillsModel]()

    init() {
        self.items = []
    }
    
}
