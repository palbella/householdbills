//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI


struct CategoryModel: Hashable, Identifiable {

     var id: Int32
     var name: String
    var iconContent: String
    var iconColor: String

//    init(id: Int32, name: String, iconContent: String, iconColor: String) {
//        self.id = id
//        self.name = name
//        self.iconContent = iconContent
//        self.iconColor = iconColor
//    }
    
    init() {
        self.id = 0
        self.name = ""
        self.iconContent = ""
        self.iconColor = ""
    }
}



class GetCategories: ObservableObject {
    @Published var items = [CategoryModel]()

    init() {
        self.items = [

        ]
    }
}
