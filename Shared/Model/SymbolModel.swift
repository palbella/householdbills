//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI


struct Symbol: Hashable, Identifiable {

     var id: Int
     var name: String
    var content: String
    var type: String

    init(id: Int, name: String, content: String, type: String) {
        self.id = id
        self.name = name
        self.content = content
        self.type = type
    }

    init() {
        self.id = 0
        self.name = ""
        self.content = ""
        self.type = ""
    }
}





class GetUnits: ObservableObject {
    @Published var items = [Symbol]()

    init() {
        self.items = [
            Symbol(id: 0, name: LocalizedStringKey("Kilometers").toString(), content: "Km", type: "kilometer"),
            Symbol(id: 1, name: LocalizedStringKey("Miles").toString(), content: "Mi", type: "milla"),

        ]
    }
}
