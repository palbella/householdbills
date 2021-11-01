//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI


struct SplitBillsModel: Hashable, Identifiable {

     var id: Int
     var name: String
    var amount: Double
    var result: Double
    var selected: Bool
    
    init() {
        self.id = 0
        self.name = ""
        self.result = 0
        self.amount = 0
        self.selected = false
    }
}



class GetSplitBills: ObservableObject {
    @Published var items = [SplitBillsModel]()

    init() {
        self.items = []
    }
    
}
