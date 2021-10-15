//
//  CarModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/2/21.
//

import SwiftUI
import CoreData


struct CarModel: Hashable, Identifiable {

     var id: UUID
     var name: String
     var symbol: String
     var amount: Int32
    var iconContent: String
    var iconColor: String
    var alert: Bool

    init(id: UUID, name: String, symbol: String, amount: Int32, iconContent: String, iconColor: String, alert: Bool) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.amount = amount
        self.iconContent = iconContent
        self.iconColor = iconColor
        self.alert = alert
    }
    
    init() {
        self.id = UUID()
        self.name = ""
        self.symbol = ""
        self.amount = 0
        self.iconContent = ""
        self.iconColor = ""
        self.alert = false
    }
}



class GetCars: ObservableObject {
    @Published var items = [CarModel]()

    init() {
        self.items = [

        ]
    }
}


struct CarServiceModel: Hashable, Identifiable {

     var id: UUID
     var name: String
     var months: Int32
     var amount: Int32
    var serviceAmount: Int32
    var date: Date

    init(id: UUID, name: String, months: Int32, amount: Int32, serviceAmount: Int32, date: Date) {
        self.id = id
        self.name = name
        self.months = months
        self.amount = amount
        self.date = date
        self.serviceAmount = serviceAmount
    }
    
    init() {
        self.id = UUID()
        self.name = ""
        self.months = 0
        self.amount = 0
        self.serviceAmount = 0
        self.date = Date()
    }
}

