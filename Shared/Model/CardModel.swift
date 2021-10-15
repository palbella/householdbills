//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI


struct CardModel: Hashable, Identifiable {

     var id: Int
     var name: String
    var order: Int16
    var visible: Bool

    init(id: Int, name: String, order: Int16, visible: Bool) {
        self.id = id
        self.name = name
        self.order = order
        self.visible = visible
    }
    
    init() {
        self.id = 0
        self.name = ""
        self.order = 0
        self.visible = true
    }
}




class GetCards: ObservableObject {
    @Published var items = [CardModel]()

    init() {
        self.items = [
            
        ]
    }
}
