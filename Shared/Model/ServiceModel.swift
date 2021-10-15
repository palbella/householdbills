//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI


struct ServiceModel: Hashable, Identifiable {

     var id: UUID
     var name: String
    var amount: Int32
    var months: Int32


    
    init() {
        self.id = UUID()
        self.name = ""
        self.months = 0
        self.amount = 0
    }
}




class GetServicess: ObservableObject {
    @Published var items = [ServiceModel]()

    init() {
        self.items = [
            
        ]
    }
}
