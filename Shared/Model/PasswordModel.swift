//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI


struct PasswordModel: Hashable, Identifiable {

     var id: UUID
     var name: String
    var password: String
    var code: String


    
    init() {
        self.id = UUID()
        self.name = ""
        self.password = ""
        self.code = ""
    }
}



class GetPasswords: ObservableObject {
    @Published var items = [PasswordModel]()

    init() {
        self.items = [

        ]
    }
}
